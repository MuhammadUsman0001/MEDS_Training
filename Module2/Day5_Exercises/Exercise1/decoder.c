#include "decoder.h"
#include <stdio.h>

void decode(uint32_t instr) {
    uint32_t opcode = instr & 0x7F;
    uint32_t rd = (instr >> 7) & 0x1F;
    uint32_t rs1 = (instr >> 15) & 0x1F;
    uint32_t rs2 = (instr >> 20) & 0x1F;
    uint32_t funct3 = (instr >> 12) & 0x7;
    uint32_t funct7 = (instr >> 25) & 0x7F;

    LOG("Decoding instruction: 0x%08X", instr);
    printf("opcode=0x%02X rd=%u rs1=%u rs2=%u funct3=%u funct7=%u\n",
           opcode, rd, rs1, rs2, funct3, funct7);
}