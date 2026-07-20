// Dataflow style: continuous assign statements
module half_adder_assign (
    input  logic a, b,
    output logic sum, carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule

// OR gate for carry combination
module or_gate (
    input  logic a, b,
    output logic y
);
    assign y = a | b;
endmodule

// Full Adder built structurally from two half adders and an OR gate
module full_adder_structural (
    input  logic a, b, cin,
    output logic sum, cout
);
    logic sum1, carry1, carry2;

    // First half adder: a + b
    half_adder_assign ha1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(carry1)
    );

    // Second half adder: sum1 + cin
    half_adder_assign ha2 (
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry(carry2)
    );

    // OR gate combines carries from both half adders
    or_gate or1 (
        .a(carry1),
        .b(carry2),
        .y(cout)
    );
endmodule
  
// Procedural style: always_comb with if-else structure
module half_adder_proc (
    input  logic a, b,
    output logic sum, carry
);
    always_comb begin
        if (a & b) begin
            sum   = 1'b0;
            carry = 1'b1;
        end 
        else if (a | b) begin
            sum   = 1'b1;
            carry = 1'b0;
        end 
        else begin
            sum   = 1'b0;
            carry = 1'b0;
        end
    end
endmodule