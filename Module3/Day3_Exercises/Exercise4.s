.data
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100     # sorted array
len:   .word 10                                          # number of elements

msg_prompt: .string "Enter target: "
msg_output: .string "Index is: "

.text
.globl main

main:
    # Prompt
    li   a0, 4
    la   a1, msg_prompt
    ecall

    # Read target
    li   a0, 5
    ecall
    mv   s0, a0             # s0 = target

    # Newline (optional but neat)
    li   a0, 11
    li   a1, 10
    ecall
    
    # Setup binary search
    la   s1, array          # s1 = base
    lw   s2, len            # s2 = N
    li   t0, 0              # low = 0
    addi t1, s2, -1         # high = N-1

binary_search:
    bgt  t0, t1, not_found

    # mid = (low + high) / 2
    add  t2, t0, t1
    srli t2, t2, 1

    # load array[mid]
    slli t3, t2, 2
    add  t3, s1, t3
    lw   t4, 0(t3)          # t4 = array[mid]

    # compare
    beq  s0, t4, found
    blt  s0, t4, go_left

    # go right
    addi t0, t2, 1
    j    binary_search

go_left:
    addi t1, t2, -1
    j    binary_search

found:
    mv   t5, t2             # t5 = index found
    j    print

not_found:
    li   t5, -1             # t5 = -1

print:
    # Prompt
    li   a0, 4
    la   a1, msg_output
    ecall
    
    li   a0, 1              # ecall 1 = print int
    mv   a1, t5
    ecall

    # Newline (optional but neat)
    li   a0, 11
    li   a1, 10
    ecall

    # Exit
    li   a0, 10
    ecall