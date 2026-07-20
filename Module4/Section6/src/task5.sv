module parity_gen(
  input logic [3:0] data, 
  output logic parity );
  
  // Reduction XOR: parity = 1 if odd number of 1s are in data
  assign parity = ^data;
endmodule