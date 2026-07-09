 .data
 message: .string "Hello MEDS!"
 .text 
 main:
    la   a1, message
    li a0,4
    mv a2,a1
    ecall
    li a0,10
    ecall