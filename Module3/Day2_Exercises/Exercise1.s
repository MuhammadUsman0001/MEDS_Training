.text
main:
    li t0,12
    li t1,64
    #shifts
    slli t2,t0,3
    srli t3,t1,2
    #substraction-final answer
    sub t4,t2,t3
    #printing and exiting
    li a0,1
    mv a1,t4
    ecall
    li a0,10
    ecall