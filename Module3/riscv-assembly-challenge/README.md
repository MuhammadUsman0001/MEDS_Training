# Module 3 – Grand Assignment

**RISC-V Instruction Set Architecture (RV32I)**  
**Summer Training Programme 2026 • Cohort 4**  
**MEDS Lab – UET Lahore**

---

## 📋 Overview

This repository contains the complete implementation of the RISC‑V Assembly Grand Assignment. The project demonstrates proficiency in:

- RISC‑V assembly programming (RV32I base ISA)
- Array processing (sum, min, max, negative count, selection sort)
- **Three** recursive algorithms (Merge Sort, Tower of Hanoi, Fibonacci with Memoization)
- Instruction encoding and decoding (mini disassembler)
- Function calling conventions (stack frames, callee‑saved registers)
- Venus simulator debugging and verification

---

## 📁 Repository Structure

```
riscv-grand-assignment/
│
├── part1_array_ops.s                 # Base: sum, min, max, count_negative
├── part1_array_ops_bonus.s           # Bonus: +selection_sort + sorted print
│
├── part2_recursion_fibonacci.s       # Option C: Fibonacci with Memoization
├── part2_recursion_merge_sort.s      # Option A: Recursive Merge Sort
├── part2_recursion_tower_of_hanoi.s  # Option B: Tower of Hanoi
│
├── part3_encoding.s                  # Base: extract opcode, rd, rs1, funct3
├── part3_encoding_bonus.s            # Bonus: mini disassembler (prints mnemonics)
│
├── docs/
│   ├── ENCODING_WORKSHEET.md         # Hand-encoded R, I, S, B, U, J instructions
│   ├── PRIVILEGED_SUMMARY.md         # Privileged architecture (CSRs, trap flow)
│   └── EXTENSION_SUMMARY.md          # "C" (Compressed) Extension summary
│
├── screenshots/                      # Venus output verification screenshots
├── README.md
└── .gitignore
```

---

## Part 1: Array Processing

**Files:** `part1_array_ops.s` (Base) | `part1_array_ops_bonus.s` (Bonus)

### Implemented Functions

| Function | Description |
| :--- | :--- |
| `sum_array` | Returns the sum of all elements |
| `find_min` | Returns the minimum value (signed) |
| `find_max` | Returns the maximum value (signed) |
| `count_negative` | Returns the number of negative elements |
| `selection_sort` *(Bonus)* | Sorts the array in ascending order in‑place using Selection Sort |

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

## Part 2: Recursive Algorithms (All Three Options)

The assignment required implementing **one** recursive algorithm, with one extra option implementation for bonus task. I implemented **all three** options to 
demonstrate mastery of recursion, stack management, and the RISC‑V calling convention.

---

### Option A: Recursive Merge Sort

**File:** `part2_recursion_merge_sort.s`

**What it does:**  
Sorts a `.data` array of signed integers using the classic **divide‑and‑conquer** recursive algorithm. It splits the array into halves, recursively sorts each half, and then merges them back together using a temporary `.space` buffer.

**Key Features:**
- Genuine recursion (post‑order traversal: left → right → merge)
- `merge_sort` splits the array; `merge` combines sorted halves
- Uses a global `temp` buffer (`.space 400`) as a scratchpad
- Proper stack frames (16 bytes for `merge_sort`, 32 bytes for `merge`)
- Saves/restores all callee‑saved registers (`s0`–`s5`)

**Array Under Test:**
```assembly
array: .word 3, 2, 1, 0, -1, -2, -3
size:  .word 7
```

**Expected Output:**
```
Sorted array is: -3, -2, -1, 0, 1, 2, 3
```

---

### Option B: Tower of Hanoi

**File:** `part2_recursion_tower_of_hanoi.s`

**What it does:**  
Prints every move required to transfer `N` disks from rod **A** to rod **C** using rod **B** as the auxiliary. The output strictly follows the format: `"Move disk X from Y to Z"`.

**Key Features:**
- Pure recursion (pre‑order traversal: print → left → right, implemented as left → print → right)
- Handles `N` disks (configurable via `.word` in `.data`)
- Prints integers and characters using `ecall 1` and `ecall 11`
- Proper 32‑byte aligned stack frame (saves `ra`, `s0`, `s1`, `s2`, `s3`)

**Configuration:**
```assembly
disks: .word 3   # Change this value for different N
```

**Expected Output (for N = 3):**
```
Move disk 1 from A to C
Move disk 2 from A to B
Move disk 1 from C to B
Move disk 3 from A to C
Move disk 1 from B to A
Move disk 2 from B to C
Move disk 1 from A to C
```

---

### Option C: Recursive Fibonacci with Memoization

**File:** `part2_recursion_fibonacci.s`

**What it does:**  
Computes `fib(20)` using recursion and a **memoization cache** (`.data` array) to avoid recomputing the same values repeatedly. This turns an exponential‑time algorithm into a linear‑time one.

**Key Features:**
- Genuine recursion with base cases `fib(0) = 0`, `fib(1) = 1`
- Cache array (`.word` size 21) initialized to zeros
- Checks `cache[n]` before computing – returns instantly on a **cache hit**
- Stores computed values in `cache[n]` on a **cache miss**
- Proper 16‑byte aligned stack frame (saves `ra`, `s0`, `s1`)

**Array Under Test:**
```assembly
cache: .word 0, 0, 0, ... 0   # 21 elements
n:     .word 20
```

**Expected Output:**
```
fib(n) of given number(n=20) is: 6765
```

---

## Part 3: Instruction Encoding & Decoding

**Files:** `part3_encoding.s` (Base) | `part3_encoding_bonus.s` (Bonus)

### Base (Field Extraction)

Loads 6 pre‑defined 32‑bit hex instructions as `.word` data.  
Extracts and prints the following fields using **shift‑and‑mask** operations:

- `opcode` (bits 6:0)
- `rd` (bits 11:7)
- `rs1` (bits 19:15)
- `funct3` (bits 14:12)

### Bonus (Mini Disassembler)

Prints the **actual instruction mnemonic** (`add`, `addi`, `sw`, `beq`, `lui`, `jal`) in addition to the field values. Distinguishes `add` from `sub` by checking `funct7`.

### Test Instructions

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

## Self‑Study Deliverables

The following documents are included in the `docs/` folder:

| File | Description |
| :--- | :--- |
| `ENCODING_WORKSHEET.md` | Hand‑encoded instructions (R, I, S, B, U, J formats) with full binary/hex breakdowns |
| `PRIVILEGED_SUMMARY.md` | One‑page summary of RISC‑V privileged architecture covering CSRs and trap handling flow |
| `EXTENSION_SUMMARY.md` | Half‑page summary of the **C (Compressed) Extension** – code size reduction and benefits |

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
- **Console:** Displays printed results.
- **Registers:** Verify register values.
- **Memory (Data segment):** Inspect arrays, cache, and `temp` buffer.

---

## Calling Convention Compliance

All functions strictly follow the RISC‑V ABI:

| Function | Callee‑Saved Registers Used | Saved/Restored? | Stack Size (Aligned) |
| :--- | :--- | :--- | :--- |
| `sum_array` | None | N/A (leaf, uses `t` regs) | 0 |
| `find_min` | None | N/A (leaf, uses `t` regs) | 0 |
| `find_max` | None | N/A (leaf, uses `t` regs) | 0 |
| `count_negative` | None | N/A (leaf, uses `t` regs) | 0 |
| `selection_sort` | `s0`–`s3` | Yes | 16 bytes |
| `merge_sort` | `s0`, `s1`, `s2` | Yes | 16 bytes |
| `merge` | `s0`–`s5` | Yes | 32 bytes |
| `hanoi` | `s0`, `s1`, `s2`, `s3` | Yes | 32 bytes |
| `print_move` | `s0`, `s1`, `s2` | Yes | 16 bytes |
| `fib_memo` | `s0`, `s1` | Yes | 16 bytes |

---

## Screenshots

All Venus output screenshots are stored in the `screenshots/` folder for verification.

---

## 🎯 Grand Assignment Outcomes

Through this assignment, the following skills and concepts have been successfully demonstrated:

- Designing and implementing RISC‑V assembly programs for array processing (sum, min, max, negative count, and selection sort).
- Building a mini disassembler that extracts `opcode`, `rd`, `rs1`, and `funct3` using shift‑and‑mask operations.
- Implementing **three** distinct recursive algorithms (Merge Sort, Tower of Hanoi, and Memoized Fibonacci) with proper stack frame management.
- Strictly following the RISC‑V calling convention, including saving and restoring callee‑saved registers (`s0`–`s11`) and maintaining 16‑byte stack alignment.
- Documenting instruction encoding across all six formats (R, I, S, B, U, J) and summarizing privileged architecture and extensions in self‑study reports.

---

## 👤 Author

**MEDS Lab – UET Lahore**  
*Summer Training Programme 2026 • Cohort 4*

---

## 📄 License

This project is submitted as part of the MEDS Lab academic curriculum.  
All code is written for educational purposes.

