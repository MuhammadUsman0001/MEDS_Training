#include <stdio.h>
#include <stdint.h>

int32_t sign_extend(uint32_t val, int bit_width) {
    uint32_t sign_bit = 1U << (bit_width - 1);
    return (int32_t)((val ^ sign_bit) - sign_bit);
}

int main() {
    
    printf("For sign_extend(0xFFF, 12):\n");
    int32_t result = sign_extend(0xFFF, 12);
    
    printf("sign_extend(0xFFF, 12) = %d\n", result);
    printf("int32_t: 0x%08X\n", result);

    return 0;
}