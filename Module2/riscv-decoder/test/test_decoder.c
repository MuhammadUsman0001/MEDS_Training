#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "decoder.h"

// Simple unit test: decode known instructions and compare assembly strings 
static void test_decode(uint32_t instr, const char *expected_asm) {
    decoded_instr_t dec;
    char buf[128];
    decode_instruction(instr, &dec);
    decode_to_asm(&dec, buf, sizeof(buf));
    if (strcmp(buf, expected_asm) != 0) {
        fprintf(stderr, "FAIL: 0x%08X -> \"%s\", expected \"%s\"\n", instr, buf, expected_asm);
        assert(0);
    } else {
        printf("PASS: 0x%08X -> \"%s\"\n", instr, buf);
    }
}

int main(void) {
    printf("Running decoder unit tests...\n");

    // R-type 
    test_decode(0x00A28233, "add x4,x5,x10");   /* add x4, x5, x10 */
    test_decode(0x40310133, "sub x2,x2,x3");    /* sub x2, x2, x3 */
    test_decode(0x003100B3, "add x1,x2,x3");    /* add x1, x2, x3 */

    // I-type arithmetic 
    test_decode(0x00500113, "addi x2,x0,5");    /* addi x2, x0, 5 */
    test_decode(0x00A00193, "addi x3,x0,10");   /* addi x3, x0, 10 */

    // Load/Store 
    test_decode(0x0000A103, "lw x2,0(x1)");     /* lw x2, 0(x1) */
    test_decode(0x0020A023, "sw x2,0(x1)");     /* sw x2, 0(x1) */

    // Branch 
    test_decode(0xFE209CE3, "bne x1,x2,-8");    /* bne x1, x2, -8 */
    test_decode(0x00108063, "beq x1,x1,0");     /* beq x1, x1, 0 */

    // JAL 
    test_decode(0x004000EF, "jal x1,4");        /* jal x1, 4 */

    // Unknown 
    test_decode(0xDEADBEEF, "UNKNOWN");

    printf("All tests passed!\n");
    return 0;
}
