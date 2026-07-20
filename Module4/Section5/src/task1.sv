 // AND Gate
module and_gate ( 
    input  logic a, b, 
    output logic y 
); 
    assign y = a & b; 
endmodule 

// OR Gate
module or_gate ( 
    input  logic a, b, 
    output logic y 
); 
    assign y = a | b; 
endmodule 

// XOR Gate
module xor_gate ( 
    input  logic a, b, 
    output logic y 
); 
    assign y = a ^ b; 
endmodule 