#include <stdio.h>
#include <stdint.h>

#define NUM_REGS 32

void write_reg(uint32_t *regs, uint8_t rd, uint32_t value)
{
    if (rd != 0 && rd < NUM_REGS) {
        regs[rd] = value;
    }
}

uint32_t read_reg(const uint32_t *regs, uint8_t rs)
{
    if (rs < NUM_REGS) {
        return regs[rs];
    }

    return 0;
}

int main(void)
{
    uint32_t regs[NUM_REGS] = {0};

    write_reg(regs, 1, 0x12345678);
    write_reg(regs, 2, 0xDEADBEEF);
    write_reg(regs, 0, 0xFFFFFFFF);  // Ignored (x0 is hardwired to 0)

    printf("x0 = 0x%08X\n", read_reg(regs, 0));
    printf("x1 = 0x%08X\n", read_reg(regs, 1));
    printf("x2 = 0x%08X\n", read_reg(regs, 2));

    return 0;
}