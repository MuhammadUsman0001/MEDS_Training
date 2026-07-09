.text
.globl main

main:
    # 1. Reading N from the user
    li   a0, 5        
    ecall             
    mv   t0, a0       

    # 2. Initializing loop variables
    li   t1, 1        # t1 = i - current number
    li   t2, 0        # t2 = sum 

loop:
    # Checking if i > N, if so exit loop 
    bgt  t1, t0, done   # if t1 > t0, jump to done

    # Adding i to sum
    add  t2, t2, t1     # sum = sum + i

    # Incrementing i
    addi t1, t1, 1      # i = i + 1

    # Repeat loop
    j    loop

done:
    # 3. Prints the sum
    li   a0, 1         
    mv   a1, t2         
    ecall               

    # 4. Exit
    li   a0, 10        
    ecall