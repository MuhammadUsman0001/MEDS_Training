# RISC-V RV32I Instruction Decoder

A command‑line tool that reads a hexadecimal machine code file and disassembles each 32‑bit RISC‑V instruction into human‑readable assembly. This project is the Grand Assignment for **MEDS Module 2 – C Language for Hardware Engineers** (Summer Training Programme 2026).

---

## Features

- Decodes all major RV32I instruction types:
  - R‑type (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU)
  - I‑type arithmetic (ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI)
  - Load instructions (LB, LH, LW, LBU, LHU)
  - Store instructions (SB, SH, SW)
  - Branch instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
  - U‑type (LUI, AUIPC)
  - J‑type (JAL, JALR)
- Proper immediate sign‑extension
- Reports `UNKNOWN` for unsupported or invalid opcodes
- Zero memory leaks (verified with Valgrind)
- Clean, modular code with separate headers and source files

---

## Build Instructions

### Prerequisites
- GCC compiler (supports C11)
- GNU Make
- (Optional) Valgrind for memory checking

### Compilation
```bash
make            # builds with debug symbols (-g -O0)
make release    # optimized build (-O2)
make debug      # same as default
```

The executable will be placed in `bin/riscv-decoder`.

### Cleaning
```bash
make clean
```

---

## Usage

```bash
./bin/riscv-decoder <hex_file>
```

The hex file should contain one 32‑bit hexadecimal word per line (e.g., `00500113`). Empty lines and lines starting with `#` are ignored.

### Example
```bash
./bin/riscv-decoder test/programs/mixed.hex
```

---

## Sample Output

```
RISC-V RV32I Instruction Decoder
================================
Loaded 9 instructions from test/programs/mixed.hex

Addr        Hex       Assembly
--------    --------  ----------------
0x00000000: 00500113  addi x2,x0,5
0x00000004: 00A00193  addi x3,x0,10
0x00000008: 003100B3  add x1,x2,x3
0x0000000C: 40310133  sub x2,x2,x3
0x00000010: 0020A023  sw x2,0(x1)
0x00000014: 0000A103  lw x2,0(x1)
0x00000018: FE209CE3  bne x1,x2,-8
0x0000001C: 004000EF  jal x1,4
0x00000020: DEADBEEF  UNKNOWN

Decoded 9 instructions (8 valid, 1 unknown)
```

---

## Testing

The project includes both **unit tests** and **sample hex programs**.

### Run all tests
```bash
make test
```
This will:
1. Run the decoder on each sample hex file in `test/programs/`
2. Compile and execute `test/test_decoder.c` (unit tests for known instructions)

### Memory check with Valgrind
```bash
make valgrind
```
This runs the decoder on `mixed.hex` under Valgrind to verify no memory leaks or invalid accesses.

---

## Project Structure

```
riscv-decoder/
├── README.md
├── Makefile
├── .gitignore
├── include/
│   ├── common.h          # Shared macros, types, opcode enums
│   ├── decoder.h         # Decoder prototypes and decoded_instr_t
│   └── memory.h          # Hex file loading functions
├── src/
│   ├── main.c            # Entry point and CLI parsing
│   ├── decoder.c         # Instruction decode and assembly formatting
│   └── memory.c          # Memory allocation and hex file parser
├── test/
│   ├── test_decoder.c    # Unit tests for decoder correctness
│   └── programs/         # Sample hex files
│       ├── r_type.hex
│       ├── i_type.hex
│       ├── branch.hex
│       └── mixed.hex
└── docs/
    └── DESIGN.md         # Architectural decisions and design rationale
```

---

## Requirements Met

-  Fixed‑width integers (`uint32_t`, `int32_t`) used throughout
-  Bitwise operations for field extraction and sign‑extension
-  Enums for opcodes and ALU operations
-  Structs for decoded instruction representation
-  Multi‑file project with headers and include guards
-  Makefile with `all`, `clean`, `test`, `debug`, `valgrind` targets
-  No memory leaks (Valgrind‑verified)
-  Inline comments on non‑obvious code
-  README with build/usage/sample output
-  DESIGN.md explaining key decisions

---

## License

This project is for educational purposes as part of the MEDS Summer Training Programme 2026 at UET Lahore.

---

## Authors

Prepared by: Umer Shahid, Shehzeen Malik, Aman Murad  
Version 1.0 • April 2026
