#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>  

int main(int argc, char *argv[]) {
    // Checks if user provided an argument
    if (argc != 2) {
        printf("Usage: %s <hex_value>\n", argv[0]);
        printf("Example: %s 0xDEADBEEF\n", argv[0]);
        return 1;
    }
    
    // Parses hex string to unsigned 32-bit integer
    uint32_t value = strtoul(argv[1], NULL, 16);
    
    // Prints results
    printf("Hex:     0x%08X\n", value);
    printf("Unsigned: %u\n", value);
    printf("Signed:   %d\n", (int32_t)value);
    printf("Binary:  ");
    for (int i = 31; i >= 0; i--) {
        printf("%d", (value >> i) & 1);
        // Space every 4 bits
        if (i % 4 == 0 && i != 0) printf(" ");  
    }
    printf("\n");
    
    return 0;
}