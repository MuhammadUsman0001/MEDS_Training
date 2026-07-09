#ifndef DECODER_H
#define DECODER_H

#include <stdint.h>

#ifdef RV64
typedef uint64_t reg_t;
#define REG_FMT "0x%016lX"
#else
typedef uint32_t reg_t;
#define REG_FMT "0x%08X"
#endif

#ifdef DEBUG
#define LOG(fmt, ...) fprintf(stderr, "[%s:%d] " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#else
#define LOG(fmt, ...)
#endif

void decode(uint32_t instr);

#endif