#include "decoder.h"
//second header just for tests
#include "decoder.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <hex_instruction>\n", argv[0]);
        return 1;
    }
    uint32_t instr = (uint32_t)strtoul(argv[1], NULL, 16);
    LOG("Main: received argument %s", argv[1]);
    decode(instr);
    return 0;
}