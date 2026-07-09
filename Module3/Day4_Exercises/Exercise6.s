# Recursive power(base, exp) -> base^exp
# Test: power(2, 10) = 1024

.text
.globl main

main:
    li   a0, 2
    li   a1, 10
    call power

    mv   a1, a0
    li   a0, 1
    ecall

    li   a0, 10
    ecall

power:
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8(sp)

    mv   s0, a0         # preserve base

    beqz a1, base_case  # if exp == 0, return 1

    addi a1, a1, -1     # exp--
    call power          # a0 = base^(exp-1)
    mul  a0, s0, a0     # base * result

    j    epilogue

base_case:
    li   a0, 1

epilogue:
    lw   s0, 8(sp)
    lw   ra, 12(sp)
    addi sp, sp, 16
    ret