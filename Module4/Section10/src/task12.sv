// T flip-flop module
module t_ff (
    input  logic clk,
    input  logic rst_n,
    input  logic t,
    output logic q
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin q <= 1'b0; end
        else if (t) begin q <= ~q; end
    end
endmodule

// Modulo-10 frequency divider using T flip-flops
module mod10_divider (
    input  logic clk,
    input  logic rst_n,
    output logic pulse
);
    logic [3:0] count, next_count;
    logic [3:0] t;

    // Next-state logic: count 0..9 then wrap to 0
    always_comb begin
        if (count == 4'd9)
            next_count = 4'd0;
        else
            next_count = count + 4'd1;
    end

    // Toggle input for each flip-flop: T = q ^ next_q
    assign t = count ^ next_count;

    // Four T flip-flops for the counter
    t_ff ff0 (.clk(clk), .rst_n(rst_n), .t(t[0]), .q(count[0]));
    t_ff ff1 (.clk(clk), .rst_n(rst_n), .t(t[1]), .q(count[1]));
    t_ff ff2 (.clk(clk), .rst_n(rst_n), .t(t[2]), .q(count[2]));
    t_ff ff3 (.clk(clk), .rst_n(rst_n), .t(t[3]), .q(count[3]));

    // Pulse output: high for one cycle when count reaches 9
    assign pulse = (count == 4'd9);
endmodule