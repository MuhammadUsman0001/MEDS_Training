### Exercise 4: Hand-Encode to Hex (Field Breakdown)

| Assembly Instruction | Format | Field Breakdown | Resulting Hex |
| :--- | :--- | :--- | :--- |
| **`sub x1, x2, x3`** | R-Type | **opcode**=`0110011` (R-type), **funct3**=`000`, **funct7**=`0100000` (sub), <br> **rd**=`x1` (00001), **rs1**=`x2` (00010), **rs2**=`x3` (00011). | `0x403100B3` |
| **`ori x5, x6, 0xFF`** | I-Type | **opcode**=`0010011` (I-type), **funct3**=`110` (ori), <br> **rd**=`x5` (00101), **rs1**=`x6` (00110), **imm**=`0xFF` (000000001111). | `0x0FF36293` |
| **`sw x7, 8(x8)`** | S-Type | **opcode**=`0100011` (Store), **funct3**=`010` (sw), <br> **rs1**=`x8` (01000), **rs2**=`x7` (00111), <br> **imm[11:5]**=`0000000`, **imm[4:0]**=`01000` (for value 8). | `0x00742423` |
| **`beq x1, x2, +16`** | B-Type | **opcode**=`1100011` (Branch), **funct3**=`000` (beq), <br> **rs1**=`x1` (00001), **rs2**=`x2` (00010). <br> Offset `+16` → encoded as `16 >> 1 = 8`. <br> **Scattered Imm:** `[12]=0`, `[11]=0`, `[10:5]=000000`, `[4:1]=1000`. | `0x00208863` |

---

### Exercise 5: Decode Hex to Assembly (Field Breakdown)

| Hex Value | Binary / Field Extraction | Decoded Assembly |
| :--- | :--- | :--- |
| **`0x00A28233`** | **opcode**=`0110011` (R-type), **funct3**=`000`, **funct7**=`0000000` (add). <br> **rd**=`00100` (`x4`), **rs1**=`00101` (`x5`), **rs2**=`01010` (`x10`). | **`add x4, x5, x10`** |
| **`0x00500113`** | **opcode**=`0010011` (I-type), **funct3**=`000` (addi). <br> **rd**=`00010` (`x2`), **rs1**=`00000` (`x0`), **imm**=`000000000101` (`5`). | **`addi x2, x0, 5`** (or `li x2, 5`) |
| **`0xFE209CE3`** | **opcode**=`1100011` (B-type), **funct3**=`001` (`bne`). <br> **rs1**=`00001` (`x1`), **rs2**=`00010` (`x2`). <br> **Reconstructed Imm:** `[12]=1`, `[10:5]=111110`, `[4:1]=1110`, `[11]=0` → `111111011100` (`-36`). <br> Shift left by 1: `-36 << 1 = -72`. | **`bne x1, x2, -72`** |