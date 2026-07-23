module barrel_shifter_4 (
    input  logic [1:0] sel,
    input  logic [3:0] W,
    output logic [3:0] Y
);
    always_comb begin
        unique case (sel)
            2'b00: Y = W;
            2'b01: Y = {W[0], W[3], W[2], W[1]};
            2'b10: Y = {W[1], W[0], W[3], W[2]};
            2'b11: Y = {W[2], W[1], W[0], W[3]};
        endcase
    end
endmodule