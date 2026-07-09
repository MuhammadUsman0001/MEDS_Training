.data
pos_msg: .string "Number is Positive"
neg_msg:  .string "Number is Negative"
zero_msg:  .string "Number is Zero"

.text
.globl main

main:
    # Reading N from the user
    li   a0, 5        
    ecall             
    mv   t0, a0   
    # If number is positive
    bgt t0,zero,positive
    # If number is negative
    blt t0,zero,negative
    # If number is zero
    beqz t0,z
# If number is positive   
positive:
    li   a0, 4          
    la   a1, pos_msg   
    ecall
    j exit
# If number is negative
negative:
    li   a0, 4          
    la   a1, neg_msg  
    ecall
    j exit
# If number is zero   
z:
    li   a0, 4          
    la   a1, zero_msg    
    ecall

exit:
    # Exit program
    li   a0, 10         
    ecall
    