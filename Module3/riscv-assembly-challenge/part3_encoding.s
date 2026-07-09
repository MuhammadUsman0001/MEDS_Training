.data
instructions: .word 0x003100B3, 0x00530293, 0x00742423, 0x00208863, 0x123451B7, 0x400000EF
count:        .word 6

str_opcode:  .string "opcode: "
str_rd:      .string ", rd: "
str_rs1:     .string ", rs1: "
str_funct3:  .string ", funct3: "
newline:     .string "\n"

.text
.globl main

main:
    la    t0, instructions    # t0 = base address of instruction array
    lw    t1, count           # t1 = loop counter (6)

loop:
    beqz  t1, done            # if counter == 0, exit
    lw    t2, 0(t0)           # t2 = current instruction

    # Extracting fields using shift-and-mask
    # opcode = instruction[6:0]
    andi  t3, t2, 0x7F        # t3 = opcode

    # rd = instruction[11:7]
    srli  t4, t2, 7
    andi  t4, t4, 0x1F        # t4 = rd

    # rs1 = instruction[19:15]
    srli  t5, t2, 15
    andi  t5, t5, 0x1F        # t5 = rs1

    # funct3 = instruction[14:12]
    srli  t6, t2, 12
    andi  t6, t6, 0x7         # t6 = funct3

    # Prints opcode
    la    a1, str_opcode
    li    a0, 4
    ecall
    mv    a1, t3
    li    a0, 1
    ecall

    # Print rd
    la    a1, str_rd
    li    a0, 4
    ecall
    mv    a1, t4
    li    a0, 1
    ecall

    # Prints rs1
    la    a1, str_rs1
    li    a0, 4
    ecall
    mv    a1, t5
    li    a0, 1
    ecall

    # Prints funct3
    la    a1, str_funct3
    li    a0, 4
    ecall
    mv    a1, t6
    li    a0, 1
    ecall

    # Prints newline
    la    a1, newline
    li    a0, 4
    ecall

    addi  t0, t0, 4           # moving to next instruction
    addi  t1, t1, -1          # decrementing counter
    j     loop

done:
    li    a0, 10
    ecall