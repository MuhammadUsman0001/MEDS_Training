.data
even_msg: .string "even"
odd_msg:  .string "odd"

.text
.globl main

main:
    # 1. Reading integer from user
    li   a0, 5          
    ecall              

    # 2. Checking least significant bit using AND immediate
    andi t0, a0, 1      # t0 = N & 1  (0 if even, 1 if odd)

    # 3. Branching based on the results
    beqz t0, print_even # if t0 == 0, going to even label
    j print_odd

print_even:
    li   a0, 4          
    la   a1, even_msg   
    ecall
    j exit

print_odd:
    li   a0, 4          
    la   a1, odd_msg    
    ecall

exit:
    # 4. Exit program
    li   a0, 10         
    ecall