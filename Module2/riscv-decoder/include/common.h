#ifndef COMMON_H
#define COMMON_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

// Bit manipulation macros 
#define EXTRACT_BITS(val, high, low) (((val) >> (low)) & ((1U << ((high) - (low) + 1)) - 1))
#define SIGN_EXTEND(val, bits) (((int32_t)(val) << (32 - (bits))) >> (32 - (bits)))

// RV32I opcodes (7 bit)
typedef enum {
    OP_LOAD     = 0x03,
    OP_STORE    = 0x23,
    OP_BRANCH   = 0x63,
    OP_JALR     = 0x67,
    OP_JAL      = 0x6F,
    OP_I_TYPE   = 0x13,
    OP_R_TYPE   = 0x33,
    OP_LUI      = 0x37,
    OP_AUIPC    = 0x17,
    OP_SYSTEM   = 0x73
} opcode_t;

// funct3 for R type and I type instructions 
typedef enum {
    FUNCT3_ADD_SUB = 0x0,
    FUNCT3_SLL     = 0x1,
    FUNCT3_SLT     = 0x2,
    FUNCT3_SLTU    = 0x3,
    FUNCT3_XOR     = 0x4,
    FUNCT3_SRL_SRA = 0x5,
    FUNCT3_OR      = 0x6,
    FUNCT3_AND     = 0x7
} funct3_t;

// funct7 constants for R type (only bits [6:0]) 
#define FUNCT7_ADD   0x00
#define FUNCT7_SUB   0x20
#define FUNCT7_SLL   0x00
#define FUNCT7_SLT   0x00
#define FUNCT7_SLTU  0x00
#define FUNCT7_XOR   0x00
#define FUNCT7_SRL   0x00
#define FUNCT7_SRA   0x20
#define FUNCT7_OR    0x00
#define FUNCT7_AND   0x00

#endif // COMMON_H 