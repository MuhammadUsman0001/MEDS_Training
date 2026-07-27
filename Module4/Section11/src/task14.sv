module t_ff (
    input  logic clk,
    input  logic rst,   // active-high, asynchronous
    input  logic t,
    output logic q
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else if (t)
            q <= ~q;
        // t == 0 : hold
    end
endmodule

// Custom-sequence counter: 0 -> 1 -> 3 -> 4 -> 7 -> 0 -> ...
// Implemented with T flip-flops. Unused states (2,5,6) will self-connect to 0.

// Excitation equations (derived via T = Q(t) xor Q(t+1) ):
//   T2 = Q2Q1 + Q1Q0 + Q2Q0
//   T1 = Q1 + (Q2 ^ Q0)
//   T0 = Q1'Q0' + Q1Q0 + Q2Q1'

module custom_counter (
    input  logic       clk,
    input  logic       rst,
    output logic [2:0] q    
);
    logic t2, t1, t0;

    // Next-state (excitation) logic
    assign t2 = (q[2] & q[1]) | (q[1] & q[0]) | (q[2] & q[0]);
    assign t1 = q[1] | (q[2] ^ q[0]);
    assign t0 = (~q[1] & ~q[0]) | (q[1] & q[0]) | (q[2] & ~q[1]);

    // Three T flip-flops
    t_ff ff2 (.clk(clk), .rst(rst), .t(t2), .q(q[2]));
    t_ff ff1 (.clk(clk), .rst(rst), .t(t1), .q(q[1]));
    t_ff ff0 (.clk(clk), .rst(rst), .t(t0), .q(q[0]));

endmodule

