#include <stdio.h>
#include <stdint.h>

// Original (bad order)
struct mixed {
    uint8_t  a;
    uint32_t b;
    uint8_t  c;
    uint16_t d;
    uint8_t  e;
};

// Optimized (good order)
struct optimized {
    uint32_t b;
    uint16_t d;
    uint8_t  a;
    uint8_t  c;
    uint8_t  e;
};

int main() {
    
    printf("Original struct: %zu bytes\n", sizeof(struct mixed));
    printf("Optimized struct: %zu bytes\n", sizeof(struct optimized));
    printf("Saved: %zu bytes\n", 
           sizeof(struct mixed) - sizeof(struct optimized));

    return 0;
}