#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

uint32_t extract_field(uint32_t instruction, int high, int low) {
    int width = high - low + 1;
    uint32_t mask = (1U << width) - 1;
    return (instruction >> low) & mask;
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

int main(int argc, char *argv[]) {
    // Checks if user provided at least one hex value or not
    if (argc < 2) {
        printf("Usage: %s <hex_instruction1> <hex_instruction2> ...\n", argv[0]);
        printf("Example: %s 0x00A28233 0x00500113 0x0020A023\n", argv[0]);
        return 1;
    }
    
    printf("...( RV32 Instruction Decoder )...\n\n");
    
    // Loop through each command line argument
    for (int i = 1; i < argc; i++) {
        // Convert hex string to uint32_t
        uint32_t instr = strtoul(argv[i], NULL, 16);
        decode_rv32(instr);
    }
    
    return 0;
}