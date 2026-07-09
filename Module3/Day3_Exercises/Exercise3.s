.data
array: .word 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
len:   .word 10                     # number of elements

.text
.globl main

main:
    # 1. Initialize pointers
    la   s0, array          # s0 = base address of the array
    lw   s1, len            # s1 = number of elements
    li   t0, 0              # t0 = left index i = 0
    addi t1, s1, -1         # t1 = right index j = size - 1

reverse_loop:
    # 2. Check if i >= j (if true, we are done)
    bge  t0, t1, done_reverse

    # 3. Compute addresses: &array[i] and &array[j]
    slli t2, t0, 2          # t2 = i * 4
    add  t2, s0, t2         # t2 = address of array[i]

    slli t3, t1, 2          # t3 = j * 4
    add  t3, s0, t3         # t3 = address of array[j]

    # 4. Load values and swap
    lw   t4, 0(t2)          # t4 = array[i]
    lw   t5, 0(t3)          # t5 = array[j]

    sw   t5, 0(t2)          # array[i] = array[j]
    sw   t4, 0(t3)          # array[j] = array[i]

    # 5. Move pointers inward
    addi t0, t0, 1          # i++
    addi t1, t1, -1         # j--
    j    reverse_loop

done_reverse:
    # 6. Print the reversed array (each element on a new line)
    li   t0, 0              # t0 = index i = 0

print_loop:
    bge  t0, s1, done_print

    slli t2, t0, 2          # t2 = i * 4
    add  t2, s0, t2         # t2 = &array[i]
    lw   a1, 0(t2)          # a1 = array[i]

    li   a0, 1              # ecall 1 = print int
    ecall

    # Print newline
    li   a0, 11             # ecall 11 = print char
    li   a1, 10             # ASCII 10 = newline
    ecall

    addi t0, t0, 1
    j    print_loop

done_print:
    # 7. Exit
    li   a0, 10
    ecall