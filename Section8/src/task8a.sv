module mux4x1 (
    input  logic [3:0] d,
    input  logic [1:0] sel,
    output logic       y
);
    always_comb begin
        case (sel)
            2'b00:   y = d[0];
            2'b01:   y = d[1];
            2'b10:   y = d[2];
            2'b11:   y = d[3];
            default: y = 1'b0;
        endcase
    end
endmodule

module f_minterms (
    input  logic a, b, c,
    output logic f
);
    logic [3:0] data;

    assign data = {1'b1, 1'b0, 1'b1, c};

    mux4x1 mux_inst (
        .d   (data),
        .sel ({a, b}),
        .y   (f)
    );
endmodule