```markdown
# Direct-Mapped Cache Controller

This project implements a **direct‑mapped cache controller** with a **write‑allocate** policy. It is written in SystemVerilog and includes a full self‑checking testbench. The design is parameterised and can be adapted to different address, data, and cache sizes.

---

## Features

- Direct‑mapped organisation
- Write‑allocate policy (writes always install the address into the cache)
- Combines address decoder, storage arrays, and a **3‑state FSM** (`IDLE`, `READ`, `WRITE`, `DONE`)
- Hit/miss detection is combinational for zero‑cycle feedback
- Supports 4‑word cache lines (configurable)
- Fully synthesizable RTL

---

## Parameters

| Parameter | Default | Description |
| :--- | :--- | :--- |
| `ADDR_WIDTH` | 16 | Address bus width |
| `DATA_WIDTH` | 32 | Word width (bits) |
| `WORDS_PER_BLOCK` | 4 | Number of words per cache line |
| `NUM_BLOCKS` | 16 | Number of cache lines |

Derived parameters (computed automatically):
- `INDEX_WIDTH`  = log₂(NUM_BLOCKS)
- `OFFSET_WIDTH` = log₂(WORDS_PER_BLOCK)
- `TAG_WIDTH`    = ADDR_WIDTH – INDEX_WIDTH – OFFSET_WIDTH

---

## Module Interface

```systemverilog
module cache_controller #(
    parameter int ADDR_WIDTH      = 16,
    parameter int DATA_WIDTH      = 32,
    parameter int WORDS_PER_BLOCK = 4,
    parameter int NUM_BLOCKS      = 16
)(
    input  logic                     clk,
    input  logic                     rst,                // active‑high async reset
    input  logic                     req_valid,
    input  logic                     req_type,           // 1 = write, 0 = read
    input  logic [ADDR_WIDTH-1:0]    address,
    input  logic [DATA_WIDTH-1:0]    data_in,
    output logic [DATA_WIDTH-1:0]    data_out,
    output logic                     done,               // one‑cycle completion pulse
    output logic                     hit,
    output logic                     miss
);
```

---

## How to Simulate

### On EDA Playground

1. Copy the entire `cache_controller` module into the **design.sv** pane.
2. Copy the testbench (`cache_controller_tb`) into the **testbench.sv** pane.
3. Set:
   - Language / Testbench: `SystemVerilog`
   - Tool: `Synopsys VCS` or `Aldec Riviera-PRO`
   - Tick `Open EPWave after run`
4. Click **Run**. The simulation log will display `PASS`/`FAIL` messages and a final summary.
5. Waveforms (`dump.vcd`) are generated for debugging.

### Using a Local Simulator (e.g., VCS, ModelSim)

1. Save the RTL and testbench in separate files (or combined).
2. Compile with SystemVerilog support:
   ```bash
   vlog -sv cache_controller.sv tb_cache_controller.sv
   ```
3. Run the simulation:
   ```bash
   vsim -c tb_cache_controller -do "run -all; exit"
   ```
   or, for VCS:
   ```bash
   simv
   ```
4. View the waveform with `gtkwave dump.vcd`.

---

## Testbench Description

The self‑checking testbench verifies the following cases:

| Test | Description |
| :--- | :--- |
| 1 | Write to an empty line, then read back – **hit** expected. |
| 2 | Read a different, never‑written line – **miss** expected. |
| 3 | Two addresses mapping to the same index but with different tags – second write evicts the first; verify hit/miss accordingly. |
| 4 | Multiple writes to different indices – all reads should **hit**. |

The testbench uses helper tasks (`write_cache`, `read_cache`, `check_hit`, `check_miss`) and prints `[PASS]` or `[FAIL]` for each check. At the end, a summary with pass/fail count is displayed.

---

## Expected Output

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

## File Structure

```
.
├── cache_controller.sv      # Main RTL module (parameterised)
├── cache_controller_tb.sv   # Self‑checking testbench
└── README.md                # This file
```

---

## Author

Abdul Rafay (as per original code attribution)

---

## License

This project is provided for educational purposes. Feel free to use and modify it for learning and research.
```