// leak
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate 100 bytes but never free
    char *buffer = (char*)malloc(100);
    // Use the buffer
    buffer[0] = 'A';
    // No free(buffer);
    printf("Memory leak: allocated 100 bytes, never freed.\n");
    return 0;
}