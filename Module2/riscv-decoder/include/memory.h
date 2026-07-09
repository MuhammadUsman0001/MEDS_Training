#ifndef MEMORY_H
#define MEMORY_H

#include <stdint.h>
#include <stddef.h>

/*
 - Load a hex file (one 32 bit word per line, in hex, e.g. "00500113")
 - Returns a pointer to an array of uint32_t, and sets *num_instrs.
 - Returns NULL on failure (file not found, parse error, etc.).
 - The caller must free the returned pointer.
 */
uint32_t *load_hex_file(const char *filename, size_t *num_instrs);

#endif // MEMORY_H 