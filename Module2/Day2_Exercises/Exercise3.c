#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

void memory_dump(const uint8_t *mem, size_t size)
{
    for (size_t i = 0; i < size; i += 8) {
        printf("0x%04zX: ", i);

        for (size_t j = 0; j < 8; j++) {
            if (i + j < size) {
                printf("%02X ", mem[i + j]);
            } else {
                printf("   ");
            }

            if (j == 3) {
                printf(" ");
            }
        }

        printf(" |");

        for (size_t j = 0; j < 8 && i + j < size; j++) {
            uint8_t c = mem[i + j];
            printf("%c", isprint(c) ? c : '.');
        }

        printf("|\n");
    }
}

int main(void)
{
    uint8_t mem[] = {
        0xDE, 0xAD, 0xBE, 0xEF,
        0xCA, 0xFE, 0xBA, 0xBE,
        'H',  'e',  'l',  'l',
        'o',  '!',  '\n', 0x00
    };

    memory_dump(mem, sizeof(mem));

    return 0;
}