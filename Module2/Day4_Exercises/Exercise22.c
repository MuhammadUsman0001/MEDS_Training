// dangling pointer
#include <stdio.h>
#include <stdlib.h>

int main() {
    char *buffer = (char*)malloc(10);
    if (buffer == NULL) return 1;
    // Write something
    buffer[0] = 'X';
    // Free the memory
    free(buffer);
    // Dangling pointer: use after free
    printf("Value: %c\n", buffer[0]);  // Undefined behavior
    return 0;
}