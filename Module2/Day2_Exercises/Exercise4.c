#include <stdio.h>
#include <stdint.h>

void reverse_array(uint32_t *arr, size_t size)
{
    uint32_t *left  = arr;
    uint32_t *right = arr + size - 1;

    while (left < right) {
        uint32_t temp = *left;
        *left = *right;
        *right = temp;

        left++;
        right--;
    }
}

void print_array(const uint32_t *arr, size_t size)
{
    for (size_t i = 0; i < size; i++) {
        printf("%u ", *(arr + i));
    }
    printf("\n");
}

int main(void)
{
    uint32_t arr[] = {1, 2, 3, 4, 5};
    size_t size = sizeof(arr) / sizeof(arr[0]);

    printf("Before: ");
    print_array(arr, size);

    reverse_array(arr, size);

    printf("After : ");
    print_array(arr, size);

    return 0;
}