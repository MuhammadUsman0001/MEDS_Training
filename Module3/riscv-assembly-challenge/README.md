#  Module3 Grand Assignment

**Module 3: RISC-V Instruction Set Architecture**  
**Summer Training Programme 2026 • Cohort 4**

---

## Overview

This repository contains the complete implementation of the **RISC-V Assembly Grand Assignment**. The project demonstrates proficiency in:

- RISC-V assembly programming (RV32I base ISA)
- Array processing (sum, min, max, negative count, selection sort)
- Recursive algorithms with memoization
- Instruction encoding and decoding (mini disassembler)
- Function calling conventions (stack frames, callee-saved registers)
- Venus simulator debugging and verification

---

## Repository Structure

```
riscv-grand-assignment/
│
├── part1_array_ops.s
├── part1_array_ops_bonus.s
├── part2_recursion_fibonacci.s
├── part3_encoding.s
├── part3_encoding_bonus.s
├── docs/
│   ├── ENCODING_WORKSHEET.md
│   ├── PRIVILEGED_SUMMARY.md
│   └── EXTENSION_SUMMARY.md
├── screenshots/
│   └── (Venus output screenshots)
└── README.md
└── .gitignore

```

---

## Part 1: Array Processing

**File:** `part1_array_ops.s` (Base) | `part1_array_ops_bonus.s` (Bonus)

### Features

| Function | Description |
| :--- | :--- |
| `sum_array` | Returns the sum of all elements |
| `find_min` | Returns the minimum value (signed) |
| `find_max` | Returns the maximum value (signed) |
| `count_negative` | Returns the number of negative elements |
| `selection_sort` *(Bonus)* | Sorts the array in ascending order in-place |

### Array Under Test

```assembly
array: .word -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7
size:  .word 13
```

### Expected Output (Base)

```
Sum of array elements is: 52
Minimum from array elements is: -5
Maximum from array elements is: 7
Negative No.# of array elements are: 5
```

### Expected Output (Bonus – with Sorted Array)

```
Sum of array elements is: 52
Minimum from array elements is: -5
Maximum from array elements is: 7
Negative No.# of array elements are: 5
Sorted array is: -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7
```

---

## Part 2: Recursive Algorithm

**File:** `part2_recursion_fibonacci.s`

### Option C: Recursive Fibonacci with Memoization

Computes `fib(20)` using recursion and a `.data` cache array to avoid recomputation.

**Key Features:**
- Genuine recursion (calls itself)
- Memoization cache (`.word` array, size 21)
- Proper stack frame (saves `ra`, `s0`, `s1`)
- Base cases: `fib(0) = 0`, `fib(1) = 1`

### Expected Output

```
fib(n) of given number(n=20) is: 6765
```

---

## Part 3: Instruction Encoding & Decoding

**File:** `part3_encoding.s` (Base) | `part3_encoding_bonus.s` (Bonus)

### Base (Field Extraction)

Loads 6 hex instructions as `.word` data and extracts:
- `opcode`
- `rd`
- `rs1`
- `funct3`

Using **shift-and-mask** operations.

### Bonus (Mini Disassembler)

Prints the **actual instruction mnemonic** (`add`, `addi`, `sw`, `beq`, `lui`, `jal`).

**Test Instructions:**

| Hex Value | Expected Mnemonic |
| :--- | :--- |
| `0x003100B3` | `add` |
| `0x00530293` | `addi` |
| `0x00742423` | `sw` |
| `0x00208863` | `beq` |
| `0x123451B7` | `lui` |
| `0x400000EF` | `jal` |

### Expected Output (Bonus)

```
opcode: 51, rd: 1, rs1: 2, funct3: 0 = add
opcode: 19, rd: 5, rs1: 6, funct3: 0 = addi
opcode: 35, rd: 8, rs1: 8, funct3: 2 = sw
opcode: 99, rd: 16, rs1: 1, funct3: 0 = beq
opcode: 55, rd: 3, rs1: 8, funct3: 5 = lui
opcode: 111, rd: 1, rs1: 0, funct3: 0 = jal
```

---

## Self-Study Deliverables

The following documents are included in the `docs/` folder:

| File | Description |
| :--- | :--- |
| `ENCODING_WORKSHEET.md` | Hand-encoded instructions (R, I, S, B, U, J formats) |
| `PRIVILEGED_SUMMARY.md` | One-page summary of RISC-V privileged architecture (CSRs, trap handling flow) |
| `EXTENSION_SUMMARY.md` | Half-page summary of the **C (Compressed) Extension** |

---

## How to Run

### 1. Open Venus Simulator
Go to: [https://venus.cs61c.org/](https://venus.cs61c.org/)

### 2. Load a Program
- Copy the contents of any `.s` file into the editor.
- Or paste the code directly.

### 3. Assemble & Run
- Click **"Assemble"** (wrench icon).
- Click **"Step"** (▶|) or **"Run"** (▶▶) to execute.

### 4. View Output
- Check the **Console** panel for printed results.
- Check the **Registers** panel to verify register values.
- Check the **Memory** panel (Data segment) to inspect arrays and cache.

---

## Calling Convention Compliance

All functions follow the RISC‑V calling convention:

| Function | Callee‑Saved Registers Used | Saved/Restored? |
| :--- | :--- | :--- |
| `sum_array` | None | N/A (leaf, uses `t` regs) |
| `find_min` | None | N/A (leaf, uses `t` regs) |
| `find_max` | None | N/A (leaf, uses `t` regs) |
| `count_negative` | None | N/A (leaf, uses `t` regs) |
| `selection_sort` | `s0`–`s3` | Yes (16‑byte stack frame) |
| `fib_memo` | `s0`, `s1` | Yes (16‑byte stack frame) |

---

## Screenshots

All Venus output screenshots are stored in the `screenshots/` folder for verification.

---

## 🎓 Learning Outcomes

By completing this assignment, you have demonstrated:

- ✅ Writing and debugging RISC‑V assembly programs
- ✅ Implementing arithmetic, logical, and memory instructions
- ✅ Using branches, loops, and function calls
- ✅ Managing stack frames and following the calling convention
- ✅ Implementing recursion with memoization
- ✅ Encoding and decoding machine instructions
- ✅ Understanding privilege levels and trap handling flow

---

## Author

**MEDS Lab – UET Lahore**  
*Summer Training Programme 2026 • Cohort 4*

---

## 📄 License

This project is submitted as part of the MEDS Lab academic curriculum.
All code is written for educational purposes.
