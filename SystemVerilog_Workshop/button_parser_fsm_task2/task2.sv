module button_parser_fsm (
    input  logic clk,
    input  logic est,      
    input  logic btn_in,
    output logic btn
);

    typedef enum logic { S0, S1 } state_t;
    state_t state, next_state;

    // State register
    always_ff @(posedge clk) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state and output logic 
    always_comb begin
        // Default assignments
        next_state = state;
        btn = 1'b0;

        case (state)
            S0: begin
                if (btn_in) begin
                    next_state = S1;
                    btn = 1'b1;      // pulse for one cycle on rising edge
                end
            end
            S1: begin
                if (!btn_in)
                    next_state = S0;
                // else stay in S1; btn remains 0
            end
        endcase
    end

endmodule