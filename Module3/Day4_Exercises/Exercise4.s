.text
.globl main

main:
    sub   x1, x2, x3
    ori   x5, x6, 0xFF
    sw    x7, 8(x8)
    beq   x1, x2, +16

    li    a0, 10
    ecall