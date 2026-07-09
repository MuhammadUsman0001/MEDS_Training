.data
data: .word 0xDEADBEEF
.text
main:
    la t0,data
    lw t1,0(t0)
    # First Byte
    andi t2,t1,0xFF
    # Second Byte
    srli t3,t1,8
    andi t4,t3,0xFF
    # Half Word
    srli t3,t1,16
    
    #printing and exiting at new lines
    li a0,1
    mv a1,t2
    ecall
    li   a0, 11
    li   a1, 10          
    ecall
    
    li a0,1
    mv a1,t4
    ecall
    li   a0, 11
    li   a1, 10          
    ecall
    
    li a0,1
    mv a1,t3
    ecall
    li a0,10
    ecall