/* Smart Vending Machine Controller
   Synchronous, single-clock design combining an FSM controller with an
   integrated datapath (balance, stock, price lookup, change calculation). */

module vending_machine (
    input  logic clk,
    input  logic reset,             // active-high synchronous reset

    input  logic coin_inserted,
    input  logic select_water,
    input  logic select_juice,
    input  logic select_chocolate,
    input  logic select_chips,
    input  logic cancel,
    input  logic refill,

    output logic        dispense_water,
    output logic        dispense_juice,
    output logic        dispense_chocolate,
    output logic        dispense_chips,
    output logic        return_change,
    output logic [3:0]  change_amount,
    output logic        insufficient_balance,
    output logic        out_of_stock,
    output logic        transaction_complete,
    output logic [3:0]  current_balance
);

    // Constants
    localparam [3:0] PRICE_WATER     = 4'd2;
    localparam [3:0] PRICE_JUICE     = 4'd3;
    localparam [3:0] PRICE_CHOCOLATE = 4'd4;
    localparam [3:0] PRICE_CHIPS     = 4'd5;

    localparam [3:0] MAX_BALANCE = 4'd10;
    localparam [3:0] MAX_STOCK   = 4'd10;

    // FSM states 
    typedef enum logic [2:0] {
        S_IDLE, S_CHECK, S_DISPENSE, S_RETURN_CHANGE,
        S_COMPLETE, S_INSUFFICIENT, S_OUT_OF_STOCK, S_CANCEL
    } state_t;

    // Product selector codes (used to index product)
    localparam [1:0] WATER     = 2'd0;
    localparam [1:0] JUICE     = 2'd1;
    localparam [1:0] CHOCOLATE = 2'd2;
    localparam [1:0] CHIPS     = 2'd3;

    // Internal state
    state_t state, next_state;          
    logic [1:0] product_sel;            // product selected for this transaction

    logic [3:0] stock_water, stock_juice, stock_chocolate, stock_chips;

    // FR-10: reject simultaneous selections; exactly one bit high is valid
    logic [1:0] sel_count;
    logic       valid_select;
    assign sel_count = select_water + select_juice + select_chocolate + select_chips;
    assign valid_select = (sel_count == 2'd1);

    // Combinational lookup of price/stock for the latched selection
    logic [3:0] sel_price;
    logic [3:0] sel_stock;
    always_comb begin
        case (product_sel)
            WATER:     begin sel_price = PRICE_WATER;     sel_stock = stock_water;     end
            JUICE:     begin sel_price = PRICE_JUICE;     sel_stock = stock_juice;     end
            CHOCOLATE: begin sel_price = PRICE_CHOCOLATE; sel_stock = stock_chocolate; end
            default:   begin sel_price = PRICE_CHIPS;     sel_stock = stock_chips;     end
        endcase
    end

    // zero_stock and low_balance signals given to FSM
    logic zero_stock;
    logic low_balance;

    assign zero_stock = (sel_stock == 4'd0);
    assign low_balance = (current_balance < sel_price);

    // State register (synchronous reset)
    always_ff @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always_comb begin
        next_state = state; // default: hold
        case (state)
            S_IDLE: begin
                if (cancel)
                    next_state = S_CANCEL;
                else if (valid_select)
                    next_state = S_CHECK;
            end
            S_CHECK: begin
                if (cancel)
                    next_state = S_CANCEL;
                else if (zero_stock)
                    next_state = S_OUT_OF_STOCK;
                else if (low_balance)
                    next_state = S_INSUFFICIENT;
                else
                    next_state = S_DISPENSE;
            end
            S_DISPENSE: begin
                if (cancel)
                    next_state = S_CANCEL;
                else
                    next_state = S_RETURN_CHANGE;
            end
            S_RETURN_CHANGE: begin
                if (cancel)
                    next_state = S_CANCEL;
                else
                    next_state = S_COMPLETE;
            end
            S_COMPLETE:      next_state = S_IDLE;
            S_INSUFFICIENT:  begin
                if (cancel)
                    next_state = S_CANCEL;
                else
                    next_state = S_IDLE;
            end
            S_OUT_OF_STOCK:  begin
                if (cancel)
                    next_state = S_CANCEL;
                else
                    next_state = S_IDLE;
            end
            S_CANCEL:        next_state = S_IDLE;
            default:         next_state = S_IDLE;
        endcase
    end

    // Latch the requested product when a transaction starts
    always_ff @(posedge clk) begin
        if (reset) begin
            product_sel <= WATER;
        end 
        else if (state == S_IDLE && valid_select) begin
            if (select_water)          product_sel <= WATER;
            else if (select_juice)     product_sel <= JUICE;
            else if (select_chocolate) product_sel <= CHOCOLATE;
            else                       product_sel <= CHIPS;
        end
    end

    // Balance datapath (FR-2, FR-5, FR-6, FR-8)
    always_ff @(posedge clk) begin
        if (reset) begin
            current_balance <= 4'd0;
        end 
        else if (state == S_RETURN_CHANGE || state == S_CANCEL) begin
            current_balance <= 4'd0; // change already latched, clear balance
        end 
        else if (state == S_IDLE && coin_inserted && current_balance < MAX_BALANCE) begin
            current_balance <= current_balance + 4'd1; // extra coins past MAX ignored
        end
    end

    // Stock datapath (FR-5, FR-7, FR-9)
    always_ff @(posedge clk) begin
        if (reset) begin
            stock_water     <= MAX_STOCK;
            stock_juice     <= MAX_STOCK;
            stock_chocolate <= MAX_STOCK;
            stock_chips     <= MAX_STOCK;
        end else if (refill) begin
            stock_water     <= MAX_STOCK;
            stock_juice     <= MAX_STOCK;
            stock_chocolate <= MAX_STOCK;
            stock_chips     <= MAX_STOCK;
        end else if (state == S_DISPENSE) begin
            case (product_sel)
                WATER:     stock_water     <= stock_water     - 4'd1;
                JUICE:     stock_juice     <= stock_juice     - 4'd1;
                CHOCOLATE: stock_chocolate <= stock_chocolate - 4'd1;
                default:   stock_chips     <= stock_chips     - 4'd1;
            endcase
        end
    end

    // Change amount register: computed while leaving CHECK/IDLE,
    // held for the one-cycle RETURN_CHANGE / CANCEL pulse
    always_ff @(posedge clk) begin
        if (reset)
            change_amount <= 4'd0;
        else if (state == S_CHECK)
            change_amount <= current_balance - sel_price;
        else if (state == S_IDLE && cancel)
            change_amount <= current_balance;
        else if (cancel && state != S_IDLE && state != S_CANCEL)
            change_amount <= current_balance;
    end

    // Output logic (Moore outputs, all one-cycle pulses except current_balance)
    always_comb begin
        dispense_water       = (state == S_DISPENSE) && (product_sel == WATER);
        dispense_juice       = (state == S_DISPENSE) && (product_sel == JUICE);
        dispense_chocolate   = (state == S_DISPENSE) && (product_sel == CHOCOLATE);
        dispense_chips       = (state == S_DISPENSE) && (product_sel == CHIPS);
        return_change        = (state == S_RETURN_CHANGE) || (state == S_CANCEL);
        insufficient_balance = (state == S_INSUFFICIENT);
        out_of_stock         = (state == S_OUT_OF_STOCK);
        transaction_complete = (state == S_COMPLETE);
    end

endmodule