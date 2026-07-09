#ifndef DECODER_H
#define DECODER_H

#include "common.h"

// Decoded instruction structure 
typedef struct {
    uint32_t raw;       // original 32‑bit instruction 
    opcode_t opcode;
    uint32_t rd;
    uint32_t rs1;
    uint32_t rs2;
    uint32_t funct3;
    uint32_t funct7;
    int32_t  imm;       // sign‑extended immediate (if any) 
    bool     is_valid;  // true if known opcode 
} decoded_instr_t;

// Decode a 32‑bit instruction into a decoded_instr_t 
void decode_instruction(uint32_t instr, decoded_instr_t *dec);

// Convert decoded instruction to assembly string; returns pointer to buffer
const char *decode_to_asm(const decoded_instr_t *dec, char *buf, size_t bufsize);

#endif // DECODER_H 
