#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "decoder.h"
#include "memory.h"

static void print_instruction(uint32_t addr, uint32_t instr, const char *asm_str) {
    printf("0x%08X: %08X  %s\n", addr, instr, asm_str);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <hex_file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];
    size_t num_instrs;
    uint32_t *instructions = load_hex_file(filename, &num_instrs);
    if (!instructions) {
        fprintf(stderr, "Failed to load hex file.\n");
        return EXIT_FAILURE;
    }

    printf("RISC-V RV32I Instruction Decoder\n");
    printf("================================\n");
    printf("Loaded %zu instructions from %s\n\n", num_instrs, filename);
    printf("Addr        Hex       Assembly\n");
    printf("--------    --------  -------------------\n");

    char asm_buf[128];
    decoded_instr_t dec;
    size_t valid_count = 0;

    for (size_t i = 0; i < num_instrs; i++) {
        uint32_t instr = instructions[i];
        uint32_t addr = (uint32_t)(i * 4);  /* word address */

        decode_instruction(instr, &dec);
        const char *asm_str = decode_to_asm(&dec, asm_buf, sizeof(asm_buf));
        print_instruction(addr, instr, asm_str);

        if (dec.is_valid)
            valid_count++;
    }

    printf("\nDecoded %zu instructions (%zu valid, %zu unknown)\n",
           num_instrs, valid_count, num_instrs - valid_count);

    free(instructions);
    return EXIT_SUCCESS;
}
