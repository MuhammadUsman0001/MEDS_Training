.data
array: .word -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7
size : .word 13
sum_m: .string "Sum of array elements is: "
min_m: .string "Minimum from array elements is: "
max_m: .string "Maximum from array elements is: "
neg_m: .string "Negative No.# of array elements are: "

.text
main:
    la a0,array
    lw a1,size
    
    # Testing sum_array function
    call sum_array          # calls sum_array function
    mv    t0,a0
    la    a1,sum_m
    li    a0,4
    ecall                   # prints sum message
    mv    a1,t0
    li    a0,1
    ecall                   # prints sum of array elements
    # Print newline
    li   a0, 11             # ecall 11 = print char
    li   a1, 10             # ASCII 10 = newline
    ecall
    
    la a0,array
    lw a1,size
    # Testing find_min function
    call find_min           # calls find_min function
    mv    t0,a0
    la    a1,min_m
    li    a0,4
    ecall                   # prints minimum message
    mv    a1,t0
    li    a0,1
    ecall                   # prints minimum from array elements
    # Print newline
    li   a0, 11             # ecall 11 = print char
    li   a1, 10             # ASCII 10 = newline
    ecall
    
    la a0,array
    lw a1,size
    # Testing find_max function
    call find_max           # calls find_max function
    mv    t0,a0
    la    a1,max_m
    li    a0,4
    ecall                   # prints maximum message
    mv    a1,t0
    li    a0,1
    ecall                   # prints maximum from array elements
    # Print newline
    li   a0, 11             # ecall 11 = print char
    li   a1, 10             # ASCII 10 = newline
    ecall
    
    la a0,array
    lw a1,size
    # Testing find_max function
    call count_negative     # calls count_negative function
    mv    t0,a0
    la    a1,neg_m
    li    a0,4
    ecall                   # prints message for negative count
    mv    a1,t0
    li    a0,1
    ecall                   # prints number of negative array elements
    # Print newline
    li   a0, 11             # ecall 11 = print char
    li   a1, 10             # ASCII 10 = newline
    ecall
    
    # exiting
    li    a0,10
    ecall

# function for summing array elements
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
    j sum_loop              # loop continues   
sum_done:
    mv a0,t4
    ret

# function for finding minimum number
find_min:
    # Prologue (just used t-registers)
    lw    t0, 0(a0)          # t0 = min = array[0]
    li    t1, 1              # t1 = i = 1
    mv    t2, a1             # t2 = size

min_loop:
    bge   t1, t2, min_done   # if i >= size, exit

    slli  t3, t1, 2          # t3 = i * 4
    add   t4, a0, t3         # t4 = &array[i]
    lw    t5, 0(t4)          # t5 = array[i]

    bge   t5, t0, min_skip   # if array[i] >= min, skip
    mv    t0, t5             # min = array[i]

min_skip:
    addi  t1, t1, 1
    j     min_loop

min_done:
    mv    a0, t0
    ret
    
# function for finding maximum number
find_max:
    # Prologue (just used t-registers)
    lw    t0, 0(a0)          # t0 = max = array[0]
    li    t1, 1              # t1 = i = 1
    mv    t2, a1             # t2 = size

max_loop:
    bge   t1, t2, max_done   # if i >= size, exit

    slli  t3, t1, 2          # t3 = i * 4
    add   t4, a0, t3         # t4 = &array[i]
    lw    t5, 0(t4)          # t5 = array[i]

    ble   t5, t0, max_skip   # if array[i] <= max, skip
    mv    t0, t5             # max = array[i]

max_skip:
    addi  t1, t1, 1
    j     max_loop

max_done:
    mv    a0, t0
    ret

# function for counting number of negative array elem.
count_negative:
    # Prologue (just used t-registers)
    # Prologue (just used t-registers)
    li    t0, 0              # t0 = No# of -ve elements = 0
    li    t1, 0              # t1 = i = 1
    mv    t2, a1             # t2 = size

neg_loop:
    bge   t1, t2, neg_done   # if i >= size, exit
    
    slli  t3, t1, 2          # t3 = i * 4
    add   t4, a0, t3         # t4 = &array[i]
    lw    t5, 0(t4)          # t5 = array[i]

    bgez  t5, neg_skip      # if array[i] > 0, skip
    addi  t0, t0, 1
    addi  t1, t1, 1
    j     neg_loop

neg_skip:
    addi  t1, t1, 1
    j     neg_loop

neg_done:
    mv    a0, t0
    ret