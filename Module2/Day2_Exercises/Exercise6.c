#include <stdio.h>
#include <stdint.h>

#define MEM_SIZE 256

void store_word(uint8_t *mem, uint32_t addr, uint32_t value)
{
    if ((addr % 4) != 0 || addr + 3 >= MEM_SIZE) {
        printf("Store error: invalid address 0x%X\n", addr);
        return;
    }

    mem[addr + 0] = (value >> 0)  & 0xFF;
    mem[addr + 1] = (value >> 8)  & 0xFF;
    mem[addr + 2] = (value >> 16) & 0xFF;
    mem[addr + 3] = (value >> 24) & 0xFF;
}

uint32_t load_word(const uint8_t *mem, uint32_t addr)
{
    if ((addr % 4) != 0 || addr + 3 >= MEM_SIZE) {
        printf("Load error: invalid address 0x%X\n", addr);
        return 0;
    }

    return ((uint32_t)mem[addr + 0] << 0)  |
           ((uint32_t)mem[addr + 1] << 8)  |
           ((uint32_t)mem[addr + 2] << 16) |
           ((uint32_t)mem[addr + 3] << 24);
}

int main(void)
{
    uint8_t mem[MEM_SIZE] = {0};

    store_word(mem, 0x00, 0xDEADBEEF);

    printf("0x%08X\n", load_word(mem, 0x00));

    return 0;
}