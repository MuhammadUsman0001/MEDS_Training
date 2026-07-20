module top (
    input  logic a, b, c, d,
    output logic f_direct,   // original expression
    output logic f_nor       // pure NOR network
);

    // Implementation 1: direct assign using original expression 
    assign f_direct = (b | c | d) & (~a | b | c) & (~a | d);

    // Implementation 2: assign built purely from NOR gates
    logic a_n, n1, n2, n3;

    // Get a' using a NOR gate with tied inputs: NOR(a,a) = ~a
  	assign a_n = ~(a | a);       // same as NOR2(a, a)

    // First-level NORs
    assign n1 = ~(b | c | d);   // NOR3
    assign n2 = ~(a_n | b | c); // NOR3
    assign n3 = ~(a_n | d);     // NOR2

    // Final NOR which combines the three inverted terms
    assign f_nor = ~(n1 | n2 | n3);

endmodule