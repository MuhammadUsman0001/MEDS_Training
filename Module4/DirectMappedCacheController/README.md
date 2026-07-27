# Direct-Mapped Cache Controller

A parameterized, single-word-per-line direct-mapped cache controller in
SystemVerilog, with a self-checking testbench. Built for the MEDS Lab
Module 4 project.

## Parameters

| Parameter     | Meaning                          | Value |
|---------------|-----------------------------------|-------|
| `ADDR_WIDTH`  | Address bus width                 | 16    |
| `DATA_WIDTH`  | Word width                        | 32    |
| `INDEX_WIDTH` | log2(number of lines)             | 4 (16 lines) |

### Derived sizing ("Do Yourself" from the spec)

Each cache line holds exactly one `DATA_WIDTH`-bit word, so:

```
OFFSET_WIDTH = log2(DATA_WIDTH / 8) = log2(32/8) = 2 bits
TAG_WIDTH    = ADDR_WIDTH - INDEX_WIDTH - OFFSET_WIDTH = 16 - 4 - 2 = 10 bits
```

```
|      TAG (10 bits)      |  INDEX (4 bits)  | OFFSET (2 bits) |
|15                      6|5                2|1               0|
```

See `docs/AddressBreakdown.png` for a visual, and `docs/BlockDiagram.png`
for the module's internal structure.

## Design

- **Address decoder**: splits `addr` into `tag`, `index`, `offset` combinationally.
- **Tag / Valid / Data arrays**: `NUM_LINES = 2**INDEX_WIDTH` entries each, indexed by `index`.
- **Hit detection**: combinational — `hit = req_valid && valid[index] && (tag[index] == addr_tag)`.
- **Write policy**: write-allocate. Every write unconditionally installs
  `wdata`/`addr_tag` into the addressed line and sets its valid bit — this
  is what lets two addresses that alias to the same index but carry
  different tags demonstrate an eviction.
- **Read policy**: on a hit, `rdata` is registered out one cycle after
  the request; on a miss, `hit` is low and `rdata` is not meaningful.
- **Reset**: active-low, asynchronous; clears all valid bits (and tag/data arrays).

Interface:

```systemverilog
module cache_controller #(
    parameter int ADDR_WIDTH  = 16,
    parameter int DATA_WIDTH  = 32,
    parameter int INDEX_WIDTH = 4
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  req_valid,
    input  logic                  req_we,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wdata,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic                  hit,
    output logic                  ready
);
```

## Verification

`tb/tb_cache_controller.sv` is a self-checking testbench covering the
four required scenarios from the Day 3 spec:

1. **Write to an empty line, then read it back** → expect `hit = 1` and
   correct data.
2. **Read a different address mapping to an empty (never-written) line**
   → expect `hit = 0`.
3. **Two addresses that alias to the same index but carry different
   tags**: writing the second evicts the first (direct-mapped behavior).
   Reading the second → hit; re-reading the first → miss.
4. Every check prints a `[PASS]`/`[FAIL]` line, plus a final pass/fail summary.

The addresses used (`ADDR_WIDTH=16`, `INDEX_WIDTH=4`, `OFFSET_WIDTH=2`):

| Address  | Tag (`addr[15:6]`) | Index (`addr[5:2]`) | Notes                          |
|----------|---------------------|----------------------|---------------------------------|
| `0x0040` | 1                   | 0                    | ADDR_A                          |
| `0x0014` | 0                   | 5                    | ADDR_B — different index, unwritten |
| `0x0840` | 33                  | 0                    | ADDR_C — same index as A, different tag |

### Running the simulation

This repo was developed and hand-verified against a cycle-accurate
functional model (see the design notes above), but you'll want to run it
through a real simulator. With **Icarus Verilog**:

```bash
iverilog -g2012 -o sim rtl/cache_controller.sv tb/tb_cache_controller.sv
vvp sim
```

This prints the `[PASS]`/`[FAIL]` lines and dumps `waveforms/cache_waveform.vcd`,
which you can open with:

```bash
gtkwave waveforms/cache_waveform.vcd
```

With **Verilator** (lint + a quick sanity build):

```bash
verilator --binary -Wall --top-module tb_cache_controller \
    rtl/cache_controller.sv tb/tb_cache_controller.sv
./obj_dir/Vtb_cache_controller
```

## File Structure

```
DirectMappedCacheController/
├── rtl/
│   └── cache_controller.sv        # parameterized cache controller
├── tb/
│   └── tb_cache_controller.sv     # self-checking testbench
├── docs/
│   ├── BlockDiagram.png           # module block diagram
│   └── AddressBreakdown.png       # tag/index/offset bit layout
├── waveforms/
│   └── cache_waveform.png         # representative signal trace
│      
└── README.md
```

## Notes / next steps

- `docs/BlockDiagram.png` and `docs/AddressBreakdown.png` are generated
  diagrams matching the design as implemented.
- `waveforms/cache_waveform.png` is an **illustrative** trace showing the
  expected `req_valid` / `req_we` / `hit` / `ready` sequence for the
  testbench's scenario — regenerate the real one with GTKWave after
  running the simulator locally (commands above), then swap it in.
- To submit: push this directory as a public git repo per the deliverables.
