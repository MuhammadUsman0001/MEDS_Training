# ENCODING_WORKSHEET.md

## Hand-Encoded Instructions (One per Format)

### 1. R-Type: `add x1, x2, x3`

| Field | Bits | Binary | Value |
| :--- | :--- | :--- | :--- |
| `funct7` | 31–25 | `0000000` | 0x00 |
| `rs2` | 24–20 | `00011` | `x3` |
| `rs1` | 19–15 | `00010` | `x2` |
| `funct3` | 14–12 | `000` | add |
| `rd` | 11–7 | `00001` | `x1` |
| `opcode` | 6–0 | `0110011` | R-type |

**Binary:** `0000000 00011 00010 000 00001 0110011` → `0000 0000 0011 0001 0000 0000 1011 0011`  
**Hex:** **`0x003100B3`**

---

### 2. I-Type: `addi x5, x6, 5`

| Field | Bits | Binary | Value |
| :--- | :--- | :--- | :--- |
| `imm` | 31–20 | `000000000101` | 5 |
| `rs1` | 19–15 | `00110` | `x6` |
| `funct3` | 14–12 | `000` | addi |
| `rd` | 11–7 | `00101` | `x5` |
| `opcode` | 6–0 | `0010011` | I-type |

**Binary:** `000000000101 00110 000 00101 0010011` → `0000 0000 0101 0011 0000 0010 1001 0011`  
**Hex:** **`0x00530293`**

---

### 3. S-Type: `sw x7, 8(x8)`

| Field | Bits | Binary | Value |
| :--- | :--- | :--- | :--- |
| `imm[11:5]` | 31–25 | `0000000` | Top 7 bits of 8 |
| `rs2` | 24–20 | `00111` | `x7` |
| `rs1` | 19–15 | `01000` | `x8` |
| `funct3` | 14–12 | `010` | sw |
| `imm[4:0]` | 11–7 | `01000` | Bottom 5 bits of 8 |
| `opcode` | 6–0 | `0100011` | S-type |

**Binary:** `0000000 00111 01000 010 01000 0100011` → `0000 0000 0111 0100 0010 0100 0010 0011`  
**Hex:** **`0x00742423`**

---

### 4. B-Type: `beq x1, x2, +16`

| Field | Bits | Binary | Value |
| :--- | :--- | :--- | :--- |
| `imm[12]` | 31 | `0` | Sign bit of offset |
| `imm[10:5]` | 30–25 | `000000` | Offset bits 10–5 |
| `rs2` | 24–20 | `00010` | `x2` |
| `rs1` | 19–15 | `00001` | `x1` |
| `funct3` | 14–12 | `000` | beq |
| `imm[4:1]` | 11–8 | `1000` | Offset bits 4–1 |
| `imm[11]` | 7 | `0` | Offset bit 11 |
| `opcode` | 6–0 | `1100011` | B-type |

> **Offset calculation:** `+16` bytes → encoded as `16 >> 1 = 8` → binary `000000001000`. Scattered as above.

**Binary:** `0 000000 00010 00001 000 1000 0 1100011` → `0000 0000 0010 0000 1000 1000 0110 0011`  
**Hex:** **`0x00208863`**

---

### 5. U-Type: `lui x3, 0x12345`

| Field | Bits | Binary | Value |
| :--- | :--- | :--- | :--- |
| `imm` | 31–12 | `0001 0010 0011 0100 0101` | 0x12345 |
| `rd` | 11–7 | `00011` | `x3` |
| `opcode` | 6–0 | `0110111` | U-type (lui) |

**Binary:** `0001 0010 0011 0100 0101 0000 0011 0111`  
**Hex:** **`0x123451B7`**  
*(Note: `0x12345` << 12 = `0x12345000`; `rd=3` at bits 11–7 = `0x180`; opcode = `0x37`; sum = `0x123451B7`)*

---

### 6. J-Type: `jal x1, 2048`

| Field | Bits | Binary | Value |
| :--- | :--- | :--- | :--- |
| `imm[20]` | 31 | `0` | Sign bit of offset |
| `imm[10:1]` | 30–21 | `1000000000` | Offset bits 10–1 |
| `imm[11]` | 20 | `0` | Offset bit 11 |
| `imm[19:12]` | 19–12 | `00000000` | Offset bits 19–12 |
| `rd` | 11–7 | `00001` | `x1` |
| `opcode` | 6–0 | `1101111` | J-type (jal) |

> **Offset calculation:** Target = `2048` bytes from PC.  
> Encoded immediate = `2048 >> 1 = 1024` = `0x400`.  
> 20‑bit immediate = `0x00400`.  
> Scattered as: `imm[20]=0`, `imm[10:1]=1000000000`, `imm[11]=0`, `imm[19:12]=00000000`.

**Binary:** `0 1000000000 0 00000000 00001 1101111` → `0100 0000 0000 0000 0000 0000 1110 1111`  
**Hex:** **`0x400000EF`**

---

## Summary Table

| Format | Instruction | Hex Encoding |
| :--- | :--- | :--- |
| R | `add x1, x2, x3` | `0x003100B3` |
| I | `addi x5, x6, 5` | `0x00530293` |
| S | `sw x7, 8(x8)` | `0x00742423` |
| B | `beq x1, x2, +16` | `0x00208863` |
| U | `lui x3, 0x12345` | `0x123451B7` |
| J | `jal x1, 2048` | `0x400000EF` |