# Direct-Mapped Cache Controller

## Objective

To design and verify a simple parameterized direct‑mapped cache controller in SystemVerilog. The controller accepts CPU read/write requests, determines hits/misses, and performs the appropriate cache operations. This project reinforces cache memory fundamentals, address decoding, tag comparison, and SystemVerilog design/verification.

---

## File Structure

```
DirectMappedCacheController/
├── docs/
│   ├── BlockDiagram.png
│   ├── FSM.png
│   ├── AddressBreakdown.png
│   └── cache_log_result.png     
├── waveforms/
│   └── cache_waveform.png       # Waveform screenshot from EPWave
├── cache.sv                     # RTL implementation (parameterised)
├── cache_tb.sv                  # Self‑checking testbench
└── README.md                    # This file
```

---

## Parameters (from Project Specification)

| Parameter           | Value | Description                        |
| :------------------ | :---: | :--------------------------------- |
| `ADDR_WIDTH`        | 16    | Address bus width                  |
| `DATA_WIDTH`        | 32    | Word width (bits)                  |
| `INDEX_WIDTH`       | 4     | log₂(16 lines) – direct‑mapped     |
| `NUM_BLOCKS`        | 16    | Number of cache lines              |
| `WORDS_PER_BLOCK`   | 4     | Words per cache line               |

**Derived (calculated automatically):**
- `TAG_WIDTH`    = `ADDR_WIDTH - INDEX_WIDTH - OFFSET_WIDTH` = 16 – 4 – 2 = 10 bits
- `OFFSET_WIDTH` = log₂(`WORDS_PER_BLOCK`) = 2 bits

---

## Implementation Overview

### Components Implemented

| Component            | Description                                                                 |
| :------------------- | :-------------------------------------------------------------------------- |
| **Address Decoder**  | Splits `address` into `tag`, `index`, `offset` using combinational logic.   |
| **Data Array**       | 2D array: `[NUM_BLOCKS-1:0][WORDS_PER_BLOCK-1:0]` of `DATA_WIDTH`-bit words.|
| **Tag Array**        | Stores `TAG_WIDTH`-bit tags for each line.                                  |
| **Valid‑bit Array**  | One bit per line indicating valid data.                                    |
| **Hit/Miss Logic**   | Combinational: `valid[index] && (tag_array[index] == tag)`.                |
| **Cache Controller** | FSM with states `IDLE`, `READ`, `WRITE`, `DONE`; controls `rd_en`, `wr_en`, `done`. |
| **Write Policy**     | **Write‑allocate**: a write always installs the address (updates data, tag, valid). |

---

## Self‑Checking Testbench

The testbench (`cache_tb.sv`) verifies the following cases automatically, printing `[PASS]` or `[FAIL]` for each:

| Test | Description |
| :--- | :--- |
| **1** | Write to an empty line, then read back – **hit** expected. |
| **2** | Read an unwritten line (different index) – **miss** expected. |
| **3** | Two addresses mapping to the same index with different tags – second write evicts the first; verify hit/miss. |
| **4** | Multiple writes to different indices – all reads should **hit**. |

**Simulation Output (Expected):**

```
=== Cache Testbench ===

--- Test 1: Write-then-read (hit) ---
[PASS] Write-then-read: data=0xa5a5a5a5

--- Test 2: Read unwritten line (miss) ---
[PASS] Read unwritten line (diff index): miss

--- Test 3: Same index, different tags ---
[PASS] Same index - second write: data=0xcafef00d
[PASS] Same index - first evicted: miss

--- Test 4: Multiple writes, different indices ---
[PASS] idx_0: data=0x1122
[PASS] idx_1: data=0x1132
[PASS] idx_2: data=0x1142
[PASS] idx_3: data=0x1152

==========================================
Summary: 7 passed, 0 failed
RESULT: ALL TESTS PASSED
==========================================
```

---

## How to Simulate

### On EDA Playground
1. Paste `cache.sv` into the **design.sv** pane.
2. Paste `cache_tb.sv` into the **testbench.sv** pane.
3. Set Language = `SystemVerilog`, Tool = `Synopsys VCS` (or `Aldec Riviera-PRO`).
4. Tick **Open EPWave after run**.
5. Click **Run** – the log will display all PASS/FAIL messages.
6. Save the waveform screenshot as `waveforms/cache_waveform.png`.

### Using a Local Simulator (e.g., VCS, ModelSim)
```bash
vlog -sv cache.sv cache_tb.sv
vsim -c cache_tb -do "run -all; exit"
# or
simv
```

---

## Deliverables

- Public Git repository with the above file structure.
- All RTL, testbench, README, and waveform screenshot included.
- Code is synthesizable, self‑checking, and fully commented (only essential comments).

---

## Author

**Muhammad Usman**  
MEDS Lab – Module 4 Project  
Summer Training Programme 2026 • Cohort 4

---

## License

For educational purposes only.
