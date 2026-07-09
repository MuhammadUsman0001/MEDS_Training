// double-free
#include <stdio.h>
#include <stdlib.h>

int main() {
    char *buffer = (char*)malloc(20);
    if (buffer == NULL) return 1;
    free(buffer);
    // Double free
    free(buffer);
    return 0;
}