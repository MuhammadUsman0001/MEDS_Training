 # int factorial(int n) { 
 #     if (n <= 1) return 1; 
 #     return n * factorial(n-1); 
 # } 
 .text
.globl main

main:
    li    a0, 10
    call  factorial
    mv    a1, a0
    li    a0, 1
    ecall
    li    a0, 10
    ecall
factorial: 
    addi sp, sp, -16 
    sw   ra, 12(sp) 
    sw   s0, 8(sp) 
    mv   s0, a0            # s0 = n (preserved across call) 
    li   t0, 1 
    ble  a0, t0, base_case 
    addi a0, s0, -1        # a0 = n-1 
    call factorial         # a0 = factorial(n-1) 
    mv   a1, a0 
    mv   a0, s0 
    call multiply           # a0 = n * factorial(n-1) 
    j    fact_ret
multiply:
    mul a0,a0,a1
    ret
base_case: 
    li   a0, 1 
fact_ret: 
    lw   s0, 8(sp) 
    lw   ra, 12(sp) 
    addi sp, sp, 16 
    ret