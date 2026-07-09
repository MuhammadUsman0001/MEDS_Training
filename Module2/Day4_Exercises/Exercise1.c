#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// Load hex file 
static int load_hex_file(const char *filename, uint8_t *memory, size_t mem_size)
{
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        perror("Cannot open hex file");
        return -1;
    }

    char line[32];
    uint32_t addr = 0;
    while (fgets(line, sizeof(line), fp) && addr + 3 < mem_size) {
        uint32_t word = (uint32_t)strtoul(line, NULL, 16);
        // Little-endian storage (RISC-V convention)
        memory[addr + 0] = (word >>  0) & 0xFF;
        memory[addr + 1] = (word >>  8) & 0xFF;
        memory[addr + 2] = (word >> 16) & 0xFF;
        memory[addr + 3] = (word >> 24) & 0xFF;
        addr += 4;
    }
    fclose(fp);
    return (int)(addr / 4);   // Number of 32-bit words loaded
}

// Dump first 'count' bytes in hex + ASCII
static void dump_bytes(const uint8_t *data, size_t count)
{
    printf("Offset  Hex\n\n");

    for (size_t i = 0; i < count; i += 16) {
        // Print offset
        printf("%04zx: ", i);

        // Print hex bytes (16 bytes per line)
        for (size_t j = 0; j < 16 && i + j < count; ++j) {
            printf("%02x ", data[i + j]);
        }
        // Pad if less than 16 bytes in last line
        //for (size_t j = count - i; j < 16; ++j) {
        //    printf("   ");
        //}
        //printf("  ");
    
        printf("\n");
    }
}

int main(int argc, char *argv[])
{
    // Command-line argument handling
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <hex_file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *hex_file = argv[1];
    const size_t MEM_SIZE = 64 * 1024;   // 64 KB

    // 1. Allocate memory
    uint8_t *memory = (uint8_t *)malloc(MEM_SIZE);
    if (!memory) {
        fprintf(stderr, "Failed to allocate %zu bytes\n", MEM_SIZE);
        return EXIT_FAILURE;
    }
    memset(memory, 0, MEM_SIZE);   // Initialize to zero

    // 2. Load hex file into memory
    int words_loaded = load_hex_file(hex_file, memory, MEM_SIZE);
    if (words_loaded < 0) {
        free(memory);
        return EXIT_FAILURE;
    }
    printf("Loaded %d words (%d bytes) from %s\n",
           words_loaded, words_loaded * 4, hex_file);

    // 3. Dump first 64 bytes
    puts("\n--- First 64 bytes of memory ---\n");
    size_t dump_size = MEM_SIZE < 64 ? MEM_SIZE : 64;
    //size_t dump_size = 64;
    dump_bytes(memory, dump_size);

    // 4. Free memory
    free(memory);
    printf("\nMemory freed. Exiting...\n");

    return EXIT_SUCCESS;
}