.text
.globl main

main:
    add  x4, x5, x10    # You expect: 0x00A28233
    addi x2, x0, 5      # You expect: 0x00500113
    bne  x1, x2, -72    # You expect: 0xFE209CE3

    li   a0, 10
    ecall