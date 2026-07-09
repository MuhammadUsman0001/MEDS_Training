#include <stdio.h>
#include <stdint.h>

// Instruction union with multiple views
typedef union { 
    // Full 32-bit word 
    uint32_t raw;          
    // R-type fields
    struct {                
        uint32_t opcode : 7; 
        uint32_t rd     : 5; 
        uint32_t funct3 : 3; 
        uint32_t rs1    : 5; 
        uint32_t rs2    : 5; 
        uint32_t funct7 : 7; 
    } r_type; 
    // I-type fields 
    struct {               
        uint32_t opcode : 7; 
        uint32_t rd     : 5; 
        uint32_t funct3 : 3; 
        uint32_t rs1    : 5; 
        uint32_t imm    : 12; 
    } i_type; 
} instruction_t;

int main() {
    instruction_t inst;
    
    // Load the instruction (addi x2, x0, 5)
    inst.raw = 0x00500113;
    
    printf("    Decoding 0x00500113 (addi x2, x0, 5)    \n\n");
    
    // Access using I-type view
    printf("Accessing Using I-type View:\n");
    printf("  opcode = 0x%02X\n", inst.i_type.opcode);
    printf("  rd     = x%u\n", inst.i_type.rd);
    printf("  funct3 = %u\n", inst.i_type.funct3);
    printf("  rs1    = x%u\n", inst.i_type.rs1);
    printf("  imm    = %d (0x%03X)\n", (int16_t)inst.i_type.imm, inst.i_type.imm);
    
    // Verify it's ADDI
    if (inst.i_type.opcode == 0x13 && inst.i_type.funct3 == 0) {
        printf("\nDecoded: ADDI x%u, x%u, %d\n", inst.i_type.rd, inst.i_type.rs1, (int16_t)inst.i_type.imm);
    }
    
    return 0;
}