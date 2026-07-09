# Exercise 5: Pseudo-instruction expansion
# This program reads an integer, checks if it's positive,
# and prints a message accordingly.

.data
msg_pos:  .string "Number is positive"
msg_non:  .string "Number is not positive"

.text
.globl main

main:
    # ----- Read integer from user -----
    li    a0, 5          # li = load immediate (pseudo)
    ecall
    mv    t0, a0         # mv = move (pseudo)

    # ----- Check if number is positive -----
    bgt   t0, zero, positive   # bgt = branch greater than (pseudo)
    # Note: bgt is a pseudo-instruction that expands to blt

    # ----- If not positive: print msg_non -----
    li    a0, 4          # print string service
    la    a1, msg_non
    ecall
    j     done

positive:
    # ----- If positive: print msg_pos -----
    li    a0, 4
    la    a1, msg_pos
    ecall

done:
    # ----- Exit -----
    li    a0, 10
    ecall