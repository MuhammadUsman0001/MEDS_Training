#include <stdio.h>
#include <stdint.h>

typedef struct {
    uint32_t x[32];
} cpu_state_t;

static const char *reg_names[32] = {
    "zero", "ra",  "sp",  "gp",
    "tp",   "t0",  "t1", "t2",
    "s0",   "s1",  "a0", "a1",
    "a2",   "a3",  "a4", "a5",
    "a6",   "a7",  "s2", "s3",
    "s4",   "s5",  "s6", "s7",
    "s8",   "s9",  "s10","s11",
    "t3",   "t4",  "t5", "t6"
};

void cpu_init(cpu_state_t *cpu)
{
    for (int i = 0; i < 32; i++)
    {
        cpu->x[i] = 0;
    }
}

void reg_write(cpu_state_t *cpu, uint8_t rd, uint32_t value)
{
    if (rd == 0)
        return;

    if (rd < 32)
        cpu->x[rd] = value;
}

uint32_t reg_read(cpu_state_t *cpu, uint8_t rs)
{
    if (rs < 32)
        return cpu->x[rs];

    return 0;
}

void dump_registers(cpu_state_t *cpu)
{
    printf("   CPU register state  \n\n");

    for (int i = 0; i < 32; i++)
    {
        printf("x%-2d (%-4s) = 0x%08x\n",i,reg_names[i],cpu->x[i]);
    }
}

int main()
{
    cpu_state_t cpu;

    cpu_init(&cpu);

    reg_write(&cpu, 1, 0x100);
    reg_write(&cpu, 2, 0x8000);
    reg_write(&cpu, 10, 42);

    printf("r1 = %u\n", reg_read(&cpu, 1));
    printf("r2 = %u\n", reg_read(&cpu, 2));
    printf("r10 = %u\n\n", reg_read(&cpu, 10));
    
    dump_registers(&cpu);

    return 0;
}