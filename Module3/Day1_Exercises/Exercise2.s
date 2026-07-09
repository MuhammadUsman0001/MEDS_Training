 .text 
 .globl main
 main:
    #takes 1st value
    addi a0,zero,5
    ecall
    add a1,zero,a0
    #takes second value
    addi a0,zero,5
    ecall
    add a2,zero,a0
    #add two values
    add  a3, a1, a2
    #prints sum of two values
    addi a0,zero,1
    mv a1,a3
    ecall
    addi a0,zero,10
    ecall