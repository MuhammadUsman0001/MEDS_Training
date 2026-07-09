.text
.globl main

main:
    # Reading N from the user
    li   a0, 5        
    ecall             
    mv   t0, a0       

    # Initializing loop variables
    li   t1, 1        # t1 = i - current number
    li   t2, 1        # t2 = product 

loop:
    # Checking if i > N, if so exit loop 
    bgt  t1, t0, done   # if t1 > t0, jump to done

    # Multiplaying i to product
    mul  t2, t2, t1     # product = product * i

    # Incrementing i
    addi t1, t1, 1      # i = i + 1

    # Repeat loop
    j    loop

done:
    # Prints the factorial
    li   a0, 1         
    mv   a1, t2         
    ecall               

    # Exit
    li   a0, 10        
    ecall