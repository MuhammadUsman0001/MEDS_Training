module request_controller (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic cancel,
    output logic busy,
    output logic done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE,
        BUSY,
        DONE
    } state_t;

    state_t state, next_state;

    // Processing counter
    localparam int PROCESS_CYCLES = 3;   // hold BUSY for 3 cycles
    logic [7:0] counter;

    // ---------- Block 1: State register ----------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            counter <= 0;
        end else begin
            state   <= next_state;
            // Counter logic in BUSY state
            if (state == BUSY) begin
                if (cancel)
                    counter <= 0;          // abort, no need to count
                else if (counter > 0)
                    counter <= counter - 1;
                // else counter stays 0
            end else if (state == IDLE && start) begin
                counter <= PROCESS_CYCLES - 1;  // load on start
            end
        end
    end

    // ---------- Block 2: Next-state logic ----------
    always_comb begin
        next_state = state;   // default: stay
        case (state)
            IDLE: begin
                if (start)
                    next_state = BUSY;
            end
            BUSY: begin
                if (cancel)
                    next_state = IDLE;
                else if (counter == 0)
                    next_state = DONE;
                // else stay BUSY
            end
            DONE: begin
                next_state = IDLE;   // always exit after one cycle
            end
            default: next_state = IDLE;
        endcase
    end

    // ---------- Block 3: Output logic (Moore) ----------
    always_comb begin
        // Default outputs
        busy = 1'b0;
        done = 1'b0;
        case (state)
            BUSY: busy = 1'b1;
            DONE: done = 1'b1;
            IDLE: ; // all zero
        endcase
    end

endmodule