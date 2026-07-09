#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// Bug #1: load_hex_file writes beyond allocated memory
int load_hex_file(const char *filename, uint8_t *memory, size_t mem_size) {
    FILE *fp = fopen(filename, "r");
    if (!fp) return -1;
    char line[32];
    uint32_t addr = 0;
    //fixed
    while (fgets(line, sizeof(line), fp) && addr + 3 < mem_size) {
        uint32_t word = (uint32_t)strtoul(line, NULL, 16);
        // Bug #1: No bounds check - can overflow memory
        memory[addr + 0] = (word >> 0) & 0xFF;
        memory[addr + 1] = (word >> 8) & 0xFF;
        memory[addr + 2] = (word >> 16) & 0xFF;
        memory[addr + 3] = (word >> 24) & 0xFF;
        addr += 4;
    }
    fclose(fp);
    return addr / 4;
}

// Bug #2: Incorrect little-endian extraction (swapped bytes)
uint32_t fetch_instruction(const uint8_t *memory, uint32_t pc) {
    // Should be little-endian: byte0 = LSB
    // Bug: treats as big-endian (byte0 = MSB)
    //fixed
    /*return (memory[pc+0] << 24) |
           (memory[pc+1] << 16) |
           (memory[pc+2] << 8) |
           (memory[pc+3] << 0);*/
    return (memory[pc+0] << 0) |
           (memory[pc+1] << 8) |
           (memory[pc+2] << 16) |
           (memory[pc+3] << 24);
}

// Dummy decode (just prints instruction)
void decode_instruction(uint32_t inst) {
    printf("Decoded: 0x%08X\n", inst);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <hex_file>\n", argv[0]);
        return 1;
    }

    // Allocate memory for 1 KB (simulated RAM)
    uint8_t *memory = (uint8_t*)malloc(1024);
    if (!memory) return 1;
    memset(memory, 0, 1024);

    // Load hex file
    int words = load_hex_file(argv[1], memory, 1024);
    printf("Loaded %d words\n", words);

    // Bug #3: Memory leak - never freed
    ////fixed

    // Simulate fetch of first 4 instructions
    for (uint32_t pc = 0; pc < 16; pc += 4) {
        uint32_t inst = fetch_instruction(memory, pc);
        decode_instruction(inst);
    }
    free(memory);
    return 0;
}