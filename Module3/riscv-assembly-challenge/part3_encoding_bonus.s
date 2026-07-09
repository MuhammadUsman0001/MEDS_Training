.data
instructions: .word 0x003100B3, 0x00530293, 0x00742423, 0x00208863, 0x123451B7, 0x400000EF
count:        .word 6

str_opcode:  .string "opcode: "
str_rd:      .string ", rd: "
str_rs1:     .string ", rs1: "
str_funct3:  .string ", funct3: "
str_mnem:    .string " = "
newline:     .string "\n"

# Mnemonic strings
str_add:     .string "add"
str_addi:    .string "addi"
str_sub:     .string "sub"
str_sw:      .string "sw"
str_beq:     .string "beq"
str_lui:     .string "lui"
str_jal:     .string "jal"
str_unknown: .string "unknown"

.text
.globl main

main:
    la    s0, instructions    # s0 = base address 
    lw    s1, count           # s1 = loop counter 

loop:
    beqz  s1, done            # if counter == 0, exit
    lw    t2, 0(s0)           # t2 = current instruction

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

    # Prints rd
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

    # BONUS: Print instruction mnemonic
    la    a1, str_mnem
    li    a0, 4
    ecall

    # Call decoder function (does NOT touch s0 or s1)
    call  decode

    # Print newline
    la    a1, newline
    li    a0, 4
    ecall

    addi  s0, s0, 4           # move to next instruction
    addi  s1, s1, -1          # decrement counter (safe!)
    j     loop

done:
    li    a0, 10
    ecall

# decode()
# Decodes the instruction in t2 and prints the mnemonic
# Uses a0-a4 for logic to avoid destroying s0/s1
decode:
    addi  sp, sp, -4
    sw    ra, 0(sp)

    # We use a0-a4 for comparisons.
    # t2 holds the instruction, t3=opcode, t6=funct3 (these remains safe)

    mv    a0, t3              # a0 = opcode

    # Check opcode against known values
    li    a1, 0x33            # R-type opcode = 51 (0x33)
    beq   a0, a1, is_R

    li    a1, 0x13            # I-type opcode = 19 (0x13)
    beq   a0, a1, is_I

    li    a1, 0x23            # S-type opcode = 35 (0x23)
    beq   a0, a1, is_S

    li    a1, 0x63            # B-type opcode = 99 (0x63)
    beq   a0, a1, is_B

    li    a1, 0x37            # U-type (lui) opcode = 55 (0x37)
    beq   a0, a1, is_U

    li    a1, 0x6F            # J-type (jal) opcode = 111 (0x6F)
    beq   a0, a1, is_J

    # Unknown opcode
    la    a0, str_unknown
    call  print_string
    j     decode_done

is_R:
    # R-type: check funct3 (t6)
    li    a0, 0               # funct3 for add/sub
    bne   t6, a0, unknown_R

    # funct3 is 0, so check funct7 (bits 31:25 of instruction t2)
    srli  a0, t2, 25
    andi  a0, a0, 0x7F        # a0 = funct7

    li    a1, 0               # funct7 for add
    beq   a0, a1, print_add

    li    a1, 0x20            # funct7 for sub
    beq   a0, a1, print_sub

unknown_R:
    la    a0, str_unknown
    call  print_string
    j     decode_done

is_I:
    # I-type: check funct3
    li    a0, 0               # funct3 for addi
    bne   t6, a0, unknown_I
    la    a0, str_addi
    call  print_string
    j     decode_done

unknown_I:
    la    a0, str_unknown
    call  print_string
    j     decode_done

is_S:
    # S-type: check funct3
    li    a0, 2               # funct3 for sw
    bne   t6, a0, unknown_S
    la    a0, str_sw
    call  print_string
    j     decode_done

unknown_S:
    la    a0, str_unknown
    call  print_string
    j     decode_done

is_B:
    # B-type: check funct3
    li    a0, 0               # funct3 for beq
    bne   t6, a0, unknown_B
    la    a0, str_beq
    call  print_string
    j     decode_done

unknown_B:
    la    a0, str_unknown
    call  print_string
    j     decode_done

is_U:
    # U-type: only lui for this opcode
    la    a0, str_lui
    call  print_string
    j     decode_done

is_J:
    # J-type: only jal for this opcode
    la    a0, str_jal
    call  print_string
    j     decode_done

print_add:
    la    a0, str_add
    call  print_string
    j     decode_done

print_sub:
    la    a0, str_sub
    call  print_string
    j     decode_done

# Helper: print_string(a0 = address of string)
print_string:
    mv    a1, a0
    li    a0, 4
    ecall
    ret

decode_done:
    lw    ra, 0(sp)
    addi  sp, sp, 4
    ret