.data
    array:        .word 1, 2, 3, 4 # array whose sum is  to be measured
    size_of_array:.word 4
.text 
main:
    li    a0,10             # value1
    li    a1,20             # value2
    call  max               # calls max function
    mv    a1,a0
    li    a0,1
    ecall                   # prints max value
    
    # Print newline
    li   a0, 11             # ecall 11 = print char
    li   a1, 10             # ASCII 10 = newline
    ecall

    la  a0,array
    lw  a1,size_of_array
    call sum_array          # calls sum_array function
    mv    a1,a0
    li    a0,1
    ecall                   # prints sum of the array
    # exiting
    li   a0, 10 
    ecall
    
 max:
    bge a0,a1,max_done
    mv  a0,a1
max_done:
    ret

sum_array:
    li   t4,0               # current sum
    li   t1,0               # i = 0
sum_loop:
    slli t2, t1, 2          # t2 = i * 4
    add  t2, a0, t2         # t2 = &array[i]
    lw   t3, 0(t2)          # t3 = array[i]
    add  t4,t4,t3           # updates sum
    addi t1,t1,1            # increaments loop
    beq  t1,a1,sum_done     # if loop goes through all array 
    j sum_loop        # loop continues   
sum_done:
    mv a0,t4
    ret