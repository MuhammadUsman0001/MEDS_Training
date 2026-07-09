.data
array: .word -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7
size : .word 13
sum_m: .string "Sum of array elements is: "
min_m: .string "Minimum from array elements is: "
max_m: .string "Maximum from array elements is: "
neg_m: .string "Negative No.# of array elements are: "
sorted_m: .string "Sorted array is: "

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
    
    la    a0, array               # a0 = array address
    lw    a1, size                # a1 = size
    # Testing selection_sort function
    call  selection_sort          # calls selection_sort function

    la    a1, sorted_m            # prints messsage for sorted array
    li    a0, 4
    ecall

    # Printing sorted array
    la    t0, array               # t0 = array base
    lw    t1, size                # t1 = size
    li    t2, 0                   # t2 = i = 0

print_sorted:
    bge   t2, t1, exit            # if i >= size, exit

    slli  t3, t2, 2               # t3 = i * 4
    add   t4, t0, t3              # t4 = &array[i]
    lw    a1, 0(t4)               # a1 = array[i]
    li    a0, 1
    ecall                         # prints an integer
    
    li    a0, 11                  # prints a comma
    li    a1, 44
    ecall
    li    a0, 11                  # prints a space
    li    a1, 32
    ecall

    addi  t2, t2, 1               # i++
    j     print_sorted
exit:
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
    
# selection_sort(a0=array, a1=size) function which sorts in ascending order
selection_sort:
    addi sp, sp, -16                # 16-byte aligned stack frame
    sw   s0, 12(sp)                 # save i (outer loop)
    sw   s1, 8(sp)                  # save j (inner loop)
    sw   s2, 4(sp)                  # save min_idx
    sw   s3, 0(sp)                  # save n (size)

    mv   s3, a1                     # s3 = n
    li   s0, 0                      # s0 = i = 0

sel_outer:
    bge  s0, s3, sel_done           # if i >= n, done

    mv   s2, s0                     # min_idx = i
    addi s1, s0, 1                  # j = i + 1

sel_inner:
    bge  s1, s3, sel_swap           # if j >= n, swap

    slli t0, s1, 2                  # t0 = j * 4
    add  t1, a0, t0                 # t1 = &array[j]
    lw   t2, 0(t1)                  # t2 = array[j]

    slli t0, s2, 2                  # t0 = min_idx * 4
    add  t3, a0, t0                 # t3 = &array[min_idx]
    lw   t4, 0(t3)                  # t4 = array[min_idx]

    bge  t2, t4, sel_skip           # if array[j] >= array[min_idx], skip
    mv   s2, s1                     # min_idx = j

sel_skip:
    addi s1, s1, 1                  # j++
    j    sel_inner

sel_swap:
    beq  s2, s0, sel_next           # if min_idx == i, skip swap

    slli t0, s0, 2                  # t0 = i * 4
    add  t1, a0, t0                 # t1 = &array[i]
    lw   t2, 0(t1)                  # t2 = array[i]

    slli t0, s2, 2                  # t0 = min_idx * 4
    add  t3, a0, t0                 # t3 = &array[min_idx]
    lw   t4, 0(t3)                  # t4 = array[min_idx]

    sw   t4, 0(t1)                  # array[i] = array[min_idx]
    sw   t2, 0(t3)                  # array[min_idx] = array[i]

sel_next:
    addi s0, s0, 1                  # i++
    j    sel_outer

sel_done:
    lw   s3, 0(sp)                  # restore n
    lw   s2, 4(sp)                  # restore min_idx
    lw   s1, 8(sp)                  # restore j
    lw   s0, 12(sp)                 # restore i
    addi sp, sp, 16                 # deallocate stack frame
    ret