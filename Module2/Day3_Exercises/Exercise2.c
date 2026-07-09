#include <stdio.h>
#include <stdint.h>

// RISC-V opcodes as an enum 
typedef enum { 
    OP_R_TYPE  = 0x33,  // Register-register 
    OP_I_TYPE  = 0x13,  // Immediate arithmetic 
    OP_LOAD    = 0x03,  // Load from memory 
    OP_STORE   = 0x23,  // Store to memory 
    OP_BRANCH  = 0x63,  // Conditional branch 
    OP_JAL     = 0x6F,  // Jump and link 
    OP_JALR    = 0x67,  // Jump and link register 
    OP_LUI     = 0x37,  // Load upper immediate 
    OP_AUIPC   = 0x17,  // Add upper immediate to PC 
    OP_SYSTEM  = 0x73,  // System instructions (ECALL, CSR) 
} opcode_t;

// Convert opcode to string
const char *opcode_to_string(opcode_t op) {
    switch (op) {
        case OP_R_TYPE:  return "R-type (ADD/SUB/AND/OR/etc.)";
        case OP_I_TYPE:  return "I-type (ADDI/ORI/XORI/etc.)";
        case OP_LOAD:    return "LOAD (LB/LH/LW/LBU/LHU)";
        case OP_STORE:   return "STORE (SB/SH/SW)";
        case OP_BRANCH:  return "BRANCH (BEQ/BNE/BLT/BGE/etc.)";
        case OP_JAL:     return "JAL (Jump and Link)";
        case OP_JALR:    return "JALR (Jump and Link Register)";
        case OP_LUI:     return "LUI (Load Upper Immediate)";
        case OP_AUIPC:   return "AUIPC (Add Upper Immediate to PC)";
        case OP_SYSTEM:  return "SYSTEM (ECALL/EBREAK/CSR ops)";
        default:         return "UNKNOWN";
    }
}

int main(void) {
    // Test all opcodes
    opcode_t opcodes[] = {
        OP_R_TYPE, OP_I_TYPE, OP_LOAD, OP_STORE,
        OP_BRANCH, OP_JAL, OP_JALR, OP_LUI, OP_AUIPC, OP_SYSTEM
    };
    
    int num_opcodes = sizeof(opcodes) / sizeof(opcodes[0]);
    
    printf("    RV32I Opcode Decoder   \n\n");
    
    for (int i = 0; i < num_opcodes; i++) {
        printf("0x%02X: %s\n", opcodes[i], opcode_to_string(opcodes[i]));
    }
    
    return 0;
}