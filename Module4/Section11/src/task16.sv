module div3_detector (
    input  logic clk,
    input  logic rst_n,
    input  logic x,          // serial input, MSB first
    output logic y           // 1 if number seen so far is divisible by 3
);

    typedef enum logic [1:0] { R0 = 2'b00, R1 = 2'b01, R2 = 2'b10 } state_t;
    state_t state, next_state;

    // ---------- Block 1: State register ----------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= R0;
        else
            state <= next_state;
    end

    // ---------- Block 2: Next-state logic (combinational) ----------
    always_comb begin
        next_state = state;   // default
        case (state)
            R0: next_state = (x == 1'b0) ? R0 : R1;
            R1: next_state = (x == 1'b0) ? R2 : R0;
            R2: next_state = (x == 1'b0) ? R1 : R2;
            default: next_state = R0;
        endcase
    end

    // ---------- Block 3: Output logic (Mealy) ----------
    // y depends on current state AND input x
    always_comb begin
        case (state)
            R0: y = (x == 1'b0);   // 1 only if x=0
            R1: y = (x == 1'b1);   // 1 only if x=1
            R2: y = 1'b0;
            default: y = 1'b0;
        endcase
    end

endmodule