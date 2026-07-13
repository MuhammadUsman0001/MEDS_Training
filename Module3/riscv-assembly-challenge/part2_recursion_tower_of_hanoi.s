# Tower of Hanoi (Recursive)
# Prints all moves to transfer N disks from A to C using B

.data
disks:     .word   3
msg_move:  .string "Move disk "
msg_from:  .string " from "
msg_to:    .string " to "
newline:   .string "\n"

.text
.globl main

main:
    lw    a0, disks            # a0 = N   (number of disks)
    li    a1, 65               # a1 = 'A' (source rod)
    li    a2, 67               # a2 = 'C' (target rod)
    li    a3, 66               # a3 = 'B' (auxiliary rod)
    call  hanoi                # start recursion

    li    a0, 10               # exit
    ecall

# Recursive function: hanoi(n, source, target, aux)
hanoi:
    addi  sp, sp, -32          # allocate 32-byte frame (16-byte aligned)
    sw    ra, 28(sp)           # save return address
    sw    s0, 24(sp)           # save original n
    sw    s1, 20(sp)           # save source
    sw    s2, 16(sp)           # save target
    sw    s3, 12(sp)           # save aux
    # sp + 0 to sp + 11 are unused (padding to keep alignment)

    mv    s0, a0               # s0 = n
    mv    s1, a1               # s1 = source
    mv    s2, a2               # s2 = target
    mv    s3, a3               # s3 = aux

    li    t0, 1                # base case: if n == 1
    beq   s0, t0, base_case

    # Step 1: Move n-1 from source to aux
    addi  a0, s0, -1            
    mv    a1, s1                # hanoi(n-1,A,C,B)
    mv    a2, s3
    mv    a3, s2
    call  hanoi

    # Step 2: Move disk n from source to target
    mv    a0, s0                # moved biggest disk from A to C
    mv    a1, s1
    mv    a2, s2
    call  print_move

    # Step 3: Move n-1 from aux to target
    addi  a0, s0, -1            # hanoi(n-1,B,C,A)
    mv    a1, s3
    mv    a2, s2
    mv    a3, s1
    call  hanoi

    j     epilogue

base_case:
    li    a0, 1
    mv    a1, s1
    mv    a2, s2
    call  print_move

epilogue:
    lw    s3, 12(sp)           # restore aux
    lw    s2, 16(sp)           # restore target
    lw    s1, 20(sp)           # restore source
    lw    s0, 24(sp)           # restore n
    lw    ra, 28(sp)           # restore return address
    addi  sp, sp, 32           # deallocate frame
    ret

# Helper function: print_move(disk, source, target)
# a0 = disk number, a1 = source char, a2 = target char
# Prints: "Move disk N from a1 to a2"
print_move:
    addi  sp, sp, -16          # preserve used registers
    sw    ra, 12(sp)
    sw    s0, 8(sp)
    sw    s1, 4(sp)
    sw    s2, 0(sp)

    mv    s0, a0               # s0 = disk number
    mv    s1, a1               # s1 = source char
    mv    s2, a2               # s2 = target char

    la    a1, msg_move         # print "Move disk "
    li    a0, 4
    ecall

    mv    a1, s0               # print disk number
    li    a0, 1
    ecall

    la    a1, msg_from         # print " from "
    li    a0, 4
    ecall

    mv    a1, s1               # print source character
    li    a0, 11
    ecall

    la    a1, msg_to           # print " to "
    li    a0, 4
    ecall

    mv    a1, s2               # print target character
    li    a0, 11
    ecall

    la    a1, newline          # print newline
    li    a0, 4
    ecall

    lw    s2, 0(sp)            # restore target
    lw    s1, 4(sp)            # restore source
    lw    s0, 8(sp)            # restore disk
    lw    ra, 12(sp)           # restore return address
    addi  sp, sp, 16           # deallocate frame
    ret