// Single-Cycle RISC-V Processor - Instruction Memory
module imem (
    input  logic [31:0] addr,
    output logic [31:0] instruction
);
    logic [31:0] mem [0:1023]; // 4KB instruction memory
    initial begin
        mem[0] = 32'h0050_0093; // addi x1, x0, 5
        mem[1] = 32'h0000_0113; // addi x2, x0, 0
        mem[2] = 32'h00A0_0193; // addi x3, z0, 10
        mem[3] = 32'h0031_5463; // bge x2, x3, 20
        mem[4] = 32'h0020_80B3; // add x1, x1, x2
        mem[5] = 32'h0011_0113; // addi x2, x2, 1
        for (int i = 6; i < 1024; i++ )
        mem[i] = 32'h00000013; // NOPs (32'h00000013) = addi x0, x0, 0
        end
    // Word-aligned access
    assign instruction = mem[addr[31:2]];
endmodule