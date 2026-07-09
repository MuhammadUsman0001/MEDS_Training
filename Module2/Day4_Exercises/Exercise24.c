// overflow test
#include<stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Allocate 10 bytes
    char *buffer = (char*)malloc(10);
    if (buffer == NULL) return 1;
    // Overflow: write 20 bytes into a 10-byte buffer
    memset(buffer, 'A', 20);   // Overwrites heap metadata
    free(buffer);
    return 0;
}