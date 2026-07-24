module up_down_counter(
	input logic clk, rst_n, up_down,
  	output logic [3:0] count );

  	always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000; end
        else if (up_down) begin
            count <= count + 1; end
        else begin
            count <= count - 1; end
    end
endmodule