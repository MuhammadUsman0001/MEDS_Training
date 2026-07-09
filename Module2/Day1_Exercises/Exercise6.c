#include <stdio.h>
#include <stdint.h>

uint32_t extract_field(uint32_t instruction, int high, int low) {
    int width = high - low + 1;
    uint32_t mask = (1U << width) - 1;
    return (instruction >> low) & mask;
}

uint32_t pack_r_type(uint32_t rd, uint32_t rs1, uint32_t rs2, 
                    uint32_t funct3, uint32_t funct7, uint32_t opcode) {
    uint32_t instruction = 0;
    instruction |= (opcode & 0x7F);                    // bits [6:0]
    instruction |= (rd & 0x1F) << 7;                   // bits [11:7]
    instruction |= (funct3 & 0x07) << 12;              // bits [14:12]
    instruction |= (rs1 & 0x1F) << 15;                 // bits [19:15]
    instruction |= (rs2 & 0x1F) << 20;                 // bits [24:20]
    instruction |= (funct7 & 0x7F) << 25;              // bits [31:25]
    return instruction;
}

void decode_rv32(uint32_t instr) {
    uint32_t opcode = extract_field(instr, 6, 0);
    uint32_t rd     = extract_field(instr, 11, 7);
    uint32_t funct3 = extract_field(instr, 14, 12);
    uint32_t rs1    = extract_field(instr, 19, 15);
    uint32_t rs2    = extract_field(instr, 24, 20);
    uint32_t funct7 = extract_field(instr, 31, 25);
    
    printf("0x%08X:\n", instr);
    printf("opcode: 0x%02X, rd: x%u, funct3: %u\n", opcode, rd, funct3);
    printf("rs1: x%u, rs2: x%u, funct7: 0x%02X\n\n", rs1, rs2, funct7);
}

int main() {
    // Original ADD instruction: add x4, x5, x10
    uint32_t original = 0x00A28233;
    
    printf("For ADD instruction: add x4, x5, x10:\n\n");
    printf("...( Original Instruction )...\n");
    decode_rv32(original);
    
    // Pack the same fields
    uint32_t packed = pack_r_type(
        4,      // rd = x4
        5,      // rs1 = x5
        10,     // rs2 = x10
        0,      // funct3 = 0 (ADD)
        0x00,   // funct7 = 0x00 (ADD)
        0x33    // opcode = 0x33 (R-type)
    );
    
    printf("...( Packed Instruction )...\n");
    decode_rv32(packed);
    
    return 0;
}