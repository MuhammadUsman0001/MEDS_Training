# Bubble Sort – sorts array in ascending order and prints result.

.data
array: .word 4, 3, 3, 2, 1
len:   .word 5

.text
.globl main

main:
    la   s0, array          # base address
    lw   s1, len            # n (number of elements)
    addi s2, s1, -1         # i = n-1 (outer loop limit)

outer_loop:
    blez s2, print          # if i <= 0, sorting done

    li   t0, 0              # j = 0 (inner loop counter)
    li   t1, 0              # swapped flag = 0

inner_loop:
    bge  t0, s2, outer_end  # if j >= i, exit inner loop

    slli t2, t0, 2          # address of array[j]
    add  t2, s0, t2
    addi t3, t2, 4          # address of array[j+1]

    lw   t4, 0(t2)          # load array[j]
    lw   t5, 0(t3)          # load array[j+1]

    ble  t4, t5, no_swap    # if in order, skip

    # swap array[j] and array[j+1]
    sw   t5, 0(t2)
    sw   t4, 0(t3)
    li   t1, 1              # mark swap occurred

no_swap:
    addi t0, t0, 1
    j    inner_loop

outer_end:
    beqz t1, print          # if no swaps, already sorted → early exit
    addi s2, s2, -1         # i--
    j    outer_loop

print:
    li   t0, 0

print_loop:
    bge  t0, s1, exit

    slli t2, t0, 2
    add  t2, s0, t2
    lw   a1, 0(t2)

    li   a0, 1              # print integer
    ecall

    li   a0, 11             # newline
    li   a1, 10
    ecall

    addi t0, t0, 1
    j    print_loop

exit:
    li   a0, 10
    ecall