#include <stdio.h>
#include <stdlib.h>

// Data Segment (initialized global) 
int global_var = 10;

// BSS Segment (uninitialized global) 
int global_bss;

void print_addresses(void)
{
    int local_var = 20;          // Stack 
    static int static_var = 30;  // Data Segment 
    int *heap_var = malloc(sizeof(int)); // Heap 

    if (heap_var == NULL) {
        perror("malloc");
        return;
    }

    *heap_var = 40;

    printf("Text   (function) : %p\n", (void *)print_addresses);
    printf("Data   (global)   : %p\n", (void *)&global_var);
    printf("Data   (static)   : %p\n", (void *)&static_var);
    printf("BSS    (global)   : %p\n", (void *)&global_bss);
    printf("Heap   (malloc)   : %p\n", (void *)heap_var);
    printf("Stack  (local)    : %p\n", (void *)&local_var);

    free(heap_var);
}

int main(void)
{
    print_addresses();
    return 0;
}