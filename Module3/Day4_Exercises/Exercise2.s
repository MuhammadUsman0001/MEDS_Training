.text
.globl main

main:
    li    a0, 10
    call  fib
    mv    a1, a0
    li    a0, 1
    ecall
    li    a0, 10
    ecall

# fib(n) stores in a0
fib:
    addi  sp, sp, -16
    sw    ra, 12(sp)
    sw    s0, 8(sp)
    sw    s1, 4(sp)

    mv    s0, a0          # s0 = n

    li    t0, 1
    beq   s0, zero, ret_0   # fib of 0 os 0
    beq   s0, t0,   ret_1   # fib os 1 is 1 ... fib series starts from 0,1,1,2,3,5...

    addi  a0, s0, -1
    call  fib             # a0 = fib(n-1)
    mv    s1, a0          # save fib(n-1) in s1 

    addi  a0, s0, -2
    call  fib             # a0 = fib(n-2)
    add   a0, s1, a0      # a0 = fib(n-1) + fib(n-2)

    j     epilogue

ret_0:
    li    a0, 0
    j     epilogue
ret_1:
    li    a0, 1

epilogue:
    lw    s1, 4(sp)
    lw    s0, 8(sp)
    lw    ra, 12(sp)
    addi  sp, sp, 16
    ret