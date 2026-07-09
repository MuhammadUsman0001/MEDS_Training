#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// exactly as given
int load_hex_file(const char *filename, uint8_t *memory, size_t mem_size)
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
        // Store as little-endian (RISC-V convention)
        memory[addr + 0] = (word >>  0) & 0xFF;
        memory[addr + 1] = (word >>  8) & 0xFF;
        memory[addr + 2] = (word >> 16) & 0xFF;
        memory[addr + 3] = (word >> 24) & 0xFF;
        addr += 4;
    }
    fclose(fp);
    return (int)(addr / 4);  // Number of words loaded
}

int main(void)
{
    // 1. Create a temporary hex file with one line: DEADBEEF
    const char *filename = "file4.hex";
    FILE *f = fopen(filename, "w");
    if (!f) {
        perror("Failed to create test.hex");
        return EXIT_FAILURE;
    }
    fprintf(f, "DEADBEEF\n");
    fclose(f);

    // 2. Allocate memory (at least 4 bytes)
    uint8_t memory[4];
    memset(memory, 0, sizeof(memory));

    // 3. Load the hex file
    int words = load_hex_file(filename, memory, sizeof(memory));
    if (words != 1) {
        fprintf(stderr, "Expected 1 word, got %d\n", words);
        remove(filename);
        return EXIT_FAILURE;
    }

    // 4. Verify little-endian bytes
    uint8_t expected[4] = {0xEF, 0xBE, 0xAD, 0xDE};
    int pass = 1;
    for (int i = 0; i < 4; i++) {
        if (memory[i] != expected[i]) {
            printf("FAIL: byte[%d] = 0x%02X, expected 0x%02X\n", i, memory[i], expected[i]);
            pass = 0;
        }
    }

    if (pass) {
        printf("SUCCESS: 0xDEADBEEF stored as little-endian: ");
        for (int i = 0; i < 4; i++)
            printf("%02X ", memory[i]);
        printf("\n");
    }

    // 5. Cleanup
    remove(filename);
    return pass ? EXIT_SUCCESS : EXIT_FAILURE;
}