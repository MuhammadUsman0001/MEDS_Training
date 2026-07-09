#include <stdio.h>
#include <string.h>

int strcat_safe(char *dest, size_t dest_size, const char *src)
{
    size_t dest_len = strlen(dest);
    size_t src_len  = strlen(src);

    if (dest_len + src_len + 1 > dest_size) {
        return -1;
    }

    memcpy(dest + dest_len, src, src_len + 1);
    return 0;
}

int main(void)
{
    char buffer[16] = "Hello";

    if (strcat_safe(buffer, sizeof(buffer), " World !") == 0) {
        printf("%s\n", buffer);
    } else {
        printf("Buffer overflow prevented\n");
    }

    return 0;
}