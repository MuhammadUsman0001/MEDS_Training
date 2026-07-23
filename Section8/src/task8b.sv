module mux2x1 (
    input  logic sel, d0, d1,
    output logic y
);
    assign y = sel ? d1 : d0;
endmodule

module majority_mux (
    input  logic a, b, c,
    output logic y
);
    logic b_and_c, b_or_c;

    // MUX to compute (b & c): if b=0 -> 0, if b=1 -> c
    mux2x1 mux_and (
        .sel (b),
        .d0  (1'b0),
        .d1  (c),
        .y   (b_and_c)
    );

    // MUX to compute (b | c): if b=0 -> c, if b=1 -> 1
    mux2x1 mux_or (
        .sel (b),
        .d0  (c),
        .d1  (1'b1),
        .y   (b_or_c)
    );

    // Final MUX: if a=0 -> (b & c), if a=1 -> (b | c)
    mux2x1 mux_final (
        .sel (a),
        .d0  (b_and_c),
        .d1  (b_or_c),
        .y   (y)
    );
endmodule