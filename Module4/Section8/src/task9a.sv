module shift_right_1 (
    input  logic       shift,
    input  logic [3:0] W,
    output logic [3:0] Y,
    output logic       k
);
    assign Y = shift ? {1'b0, W[3:1]} : W;
    assign k = shift ? W[0] : 1'b0;
endmodule