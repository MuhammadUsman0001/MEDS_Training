module cache_controller #(
    // Parameter definitions 
    parameter int ADDR_WIDTH      = 16,
    parameter int DATA_WIDTH      = 32,
    parameter int WORDS_PER_BLOCK = 4,
    parameter int NUM_BLOCKS      = 16
)(
    input  logic                     clk,
    input  logic                     rst,

    // CPU interface
    input  logic                     req_valid,   // 1 = request valid
    input  logic                     req_type,    // 1 = write, 0 = read
    input  logic [ADDR_WIDTH-1:0]    address,
    input  logic [DATA_WIDTH-1:0]    data_in,

    // Response
    output logic [DATA_WIDTH-1:0]    data_out,
    output logic                     done,        // one‑cycle completion pulse
    output logic                     hit,        
    output logic                     miss         
);

    localparam int INDEX_WIDTH     = $clog2(NUM_BLOCKS);          // 4
    localparam int OFFSET_WIDTH    = $clog2(WORDS_PER_BLOCK);     // 2
    localparam int TAG_WIDTH       = ADDR_WIDTH - INDEX_WIDTH - OFFSET_WIDTH; // 10

    // Internal signals
    logic [TAG_WIDTH-1:0]    tag;
    logic [INDEX_WIDTH-1:0]  index;
    logic [OFFSET_WIDTH-1:0] offset;

    logic wr_en, rd_en;           // derived from FSM
    logic hit_int;                // internal hit (combinational)
    logic [DATA_WIDTH-1:0] data_out_int;

    // 1. Address Decoder (combinational)
    assign tag    = address[ADDR_WIDTH-1 : ADDR_WIDTH-TAG_WIDTH];
    assign index  = address[ADDR_WIDTH-TAG_WIDTH-1 : OFFSET_WIDTH];
    assign offset = address[OFFSET_WIDTH-1 : 0];

    // 2. Cache Storage (arrays)
    logic [WORDS_PER_BLOCK-1:0][DATA_WIDTH-1:0] data_array  [NUM_BLOCKS-1:0];
    logic [TAG_WIDTH-1:0]                       tag_array   [NUM_BLOCKS-1:0];
    logic                                       valid_array [NUM_BLOCKS-1:0];

    // Hit detection (combinational)
    assign hit_int = valid_array[index] && (tag_array[index] == tag);
    assign hit     = hit_int;
    assign miss    = !hit_int;

    // 3. Cache Controller FSM 
    typedef enum logic [1:0] { IDLE, READ, WRITE, DONE } state_t;
    state_t state, next_state;

    // State register
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next‑state logic
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (req_valid)
                    next_state = req_type ? WRITE : READ;
                else
                    next_state = IDLE;
            end
            READ:  next_state = DONE;
            WRITE: next_state = DONE;
            DONE:  next_state = IDLE;
        endcase
    end

    // Output logic (controls rd_en, wr_en, done)
    always_comb begin
        rd_en = 1'b0;
        wr_en = 1'b0;
        done  = 1'b0;
        case (state)
            IDLE: ;
            READ:  rd_en = hit_int;   // only read if hit; on miss, rd_en stays 0
            WRITE: wr_en = 1'b1;      // write‑allocate: always write (hit or miss)
            DONE:  done = 1'b1;
        endcase
    end

    // 4. Memory operations (sequential)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= '0;
            for (int i = 0; i < NUM_BLOCKS; i++) begin
                valid_array[i] <= 1'b0;
                // tag_array and data_array need not be reset; valid=0 covers them
            end
        end 
        else begin
            // Read (takes priority over write to avoid conflict)
            if (rd_en) begin
                data_out <= data_array[index][offset];
            end

            // Write (write‑allocate: update data, tag, valid)
            if (wr_en) begin
                data_array[index][offset] <= data_in;
                tag_array[index]          <= tag;
                valid_array[index]        <= 1'b1;
            end
        end
    end

    // data_out is directly the output; if both rd_en and wr_en are 0, it retains its value.

endmodule