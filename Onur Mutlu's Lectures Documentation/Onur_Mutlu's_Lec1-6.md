# Onur Mutlu's Lectures (1-6) Summary

## Course Overview

**Course:** Digital Design and Computer Architecture (DDCA)
**Instructor:** Dr. Onur Mutlu
**Core Focus:** Understanding how modern computing systems are built—from transistors to complete processors—and how design decisions affect performance, power, cost, reliability, and scalability.

The course develops a complete view of computer systems by connecting low-level hardware fundamentals with high-level architectural concepts. It emphasizes both theoretical understanding and practical implementation using hardware description languages and FPGA-based design. Students learn to think critically about design trade-offs and to implement functional hardware modules, ultimately building a simple microprocessor. The course also covers advanced topics such as GPUs, systolic arrays, machine learning accelerators, and cross-layer co-design.

---

# Lecture 1: Fundamentals, Transistors and Logic Gates

## Key Themes

- Computing systems are built hierarchically, beginning with transistors as the fundamental switch.
- Hardware design requires balancing competing goals: performance, energy, cost, reliability, and security.
- Modern architectures increasingly rely on specialization and heterogeneity, combining CPUs, GPUs, and accelerators on a single chip.

## The Transformation Hierarchy

Every computational problem is transformed through multiple abstraction layers before it becomes physical electron flow:

- Problem → Algorithm → Program → System Software → ISA → Microarchitecture → Logic → Devices (Transistors) → Physics

Each layer provides a simplified view of the one below it. This layered abstraction makes it possible to design complex systems without managing every transistor individually.

## ISA and Microarchitecture

- **Instruction Set Architecture (ISA):** The formal contract between software and hardware. It defines what the hardware does (instructions, registers, memory addressing) but not how it does it.
- **Microarchitecture:** A specific implementation of an ISA. Many different microarchitectures can implement the same ISA, trading off speed, power, and area.
- This separation allows software compatibility while hardware evolves independently.

## Computer Architecture Defined

Computer architecture is the science and art of designing computing platforms, balancing multiple goals:

- **Performance** – instructions per second, latency, throughput.
- **Power** – dynamic and static power consumption.
- **Cost** – manufacturing cost, design effort.
- **Reliability** – correct operation over time, fault tolerance.
- **Security** – protection against malicious attacks.

Design goals vary widely: supercomputers prioritize maximum performance; mobile devices prioritize low power and low cost; general-purpose computers balance performance and flexibility. Modern systems are highly heterogeneous, integrating CPUs, GPUs, neural accelerators, video processors, and other specialized cores on a single chip.

## Transistors as Switches

A transistor is a voltage-controlled switch. In digital design, we abstract it as either ON (conducting) or OFF (non-conducting). Two types are used in CMOS technology:

- **NMOS (n-type):** Closes (conducts) when the gate voltage is **high** (logic 1).
- **PMOS (p-type):** Closes when the gate voltage is **low** (logic 0).

CMOS technology uses complementary pairs of NMOS and PMOS to build logic gates efficiently, with very low static power consumption because one transistor is always off in steady state.

## CMOS Logic Gates

### Inverter (NOT Gate)
- Constructed from one PMOS (connected to supply voltage, pull-up network) and one NMOS (connected to ground, pull-down network).
- When input is 0, PMOS turns on, NMOS off → output is 1.
- When input is 1, NMOS turns on, PMOS off → output is 0.
- Truth table: Input 0 → Output 1; Input 1 → Output 0.

### NAND Gate
- Two PMOS in parallel (pull-up network), two NMOS in series (pull-down network).
- Output is 0 only when **both** inputs are 1. Otherwise output is 1.
- NAND is a **universal gate** – any Boolean function can be built using only NAND gates. This makes it a fundamental building block in digital design.

### AND Gate
- Implemented as a NAND gate followed by an inverter.

## Course Philosophy and Advice

- Emphasis on **critical thinking** and understanding underlying trade-offs.
- Importance of mastering fundamentals to innovate in hardware/software co-design.
- Focus on learning and understanding rather than just grades.
- Course is challenging but rewarding, with strong community support.

## Key Takeaways

- Transistors are the foundation of all digital systems; understanding how they behave as switches is essential.
- CMOS provides efficient, reliable digital logic because it uses complementary pull-up and pull-down networks.
- NAND (and NOR) are universal building blocks, meaning a complete processor can be constructed from just one type of gate.
- The abstraction hierarchy (problem → physics) separates concerns and enables complex system design.
- Modern computer architecture is heterogeneous and specialized; knowledge of fundamentals is the key to innovation.

---

# Lecture 2: Combinational Logic

## Definition and Scope

A **combinational circuit** produces outputs that depend **only** on the current inputs. It contains no memory elements. Examples include decoders, multiplexers, adders, comparators, and arithmetic logic units (ALUs). Combinational logic forms the computational core of a processor.

## Boolean Algebra Fundamentals

Boolean algebra provides the mathematical foundation for digital logic. It operates on binary variables (0 and 1) with three basic operations:

- **AND** (·) – output is 1 only if all inputs are 1.
- **OR** (+) – output is 1 if at least one input is 1.
- **NOT** (¬) – inverts the input.

Important properties include commutativity, associativity, distributivity, and De Morgan's theorems:

- (A.B)'=A'+B'
- (A+B)'=A'B'

Duality: swapping AND/OR and 0/1 preserves truth.

### Why Boolean Algebra Matters
- Enables formal representation of any logic function.
- Allows minimization of logic expressions, reducing gate count, area, power, and delay.
- Modern logic synthesis tools (Electronic Design Automation, EDA) automate this minimization.

## Canonical Forms

Any Boolean function can be expressed in two standard forms:

- **Sum of Products (SOP):** OR of minterms (product terms where each variable appears once). Example: Y=A'B + AB' (XOR).
- **Product of Sums (POS):** AND of maxterms (sum terms). POS is less common but useful in some technologies.

These forms are essential for logic synthesis and minimization. The uniting theorem helps eliminate variables that do not affect output in certain input combinations.

## Fundamental Combinational Building Blocks

### Decoder
- Takes an n‑bit binary input and activates exactly one of \(2^n\) outputs.
- Used in memory addressing (selecting a row or word line) and instruction decoding.

### Multiplexer (MUX)
- Selects one data input from several based on select lines.
- A 2-to-1 MUX has two data inputs, one select line, and one output.
- Larger multiplexers can be built from smaller ones.
- MUXes can implement **any** Boolean function by setting data inputs appropriately – this is the basis of FPGA lookup tables (LUTs).

### Adder
- A 1‑bit full adder adds three bits (two operands and a carry‑in) and produces a sum and a carry‑out.
- Multi‑bit adders are built by cascading full adders (ripple carry adder). The carry ripples from least significant to most significant, causing linear delay O(n).
- Faster adders (carry lookahead, carry select) compute carries in parallel to reduce delay to O(log n).

### Arithmetic Logic Unit (ALU)
- Combines arithmetic (addition, subtraction) and logic (AND, OR, XOR) operations.
- Typically takes two n‑bit inputs and a function select signal and produces an n‑bit output.

### Comparator (Equality)
- An n‑bit equality comparator uses bitwise XNOR gates to compare corresponding bits.
- Output is high only if all bits match (all XNOR outputs are 1).

### Tri-State Buffers
- Act as switches controlled by an enable signal.
- When enable = 0, the output is floating (high impedance, Z), effectively disconnecting the device.
- Enable multiple devices to share a common bus without conflict. Only one device drives the bus at a time; others are in high-Z.

## Power Consumption in Digital Circuits

Digital circuits consume power in two ways:

- **Dynamic power:** Consumed when transistors switch. Approximated by `P_dynamic = C × V^2 × f`, where C is capacitance, V is supply voltage, and f is switching frequency. Dynamic power dominates in active operation.
- **Static power:** Due to leakage currents even when transistors are off. Static power becomes significant in very small transistor geometries (below 65nm).

**Key insight:** Voltage has a quadratic effect on dynamic power (actually cubic because higher voltage allows higher frequency). Reducing voltage is the most effective way to reduce power. Minimizing circuit complexity, capacitance, and switching frequency also improves efficiency.

## Design Trade-offs and Challenges

- Increasing the number of inputs to a gate (fan‑in) increases propagation delay because transistors in series have higher resistance.
- Breaking a large fan‑in gate into multiple smaller gates reduces delay but may increase area.
- Logic minimization reduces area and power but can eliminate redundancy that might be useful for reliability.
- High voltage and current stress cause transistor aging and reduce circuit lifespan.
- Ongoing innovation in transistor fabrication (FinFET, GAAFET) is essential to sustain Moore's Law.

## Key Takeaways

- Combinational circuits are the workhorses of computation, performing arithmetic and logic operations.
- Boolean algebra and canonical forms enable systematic design and optimization.
- Decoders, multiplexers, adders, and ALUs are essential building blocks reused throughout a processor.
- Multiplexers are universal – they can implement any logic function, which is why FPGAs use them as lookup tables.
- Power has become a first‑class design constraint; dynamic power depends strongly on voltage.
- Every design choice involves trade‑offs among area, speed, power, and reliability.
- Hierarchical design and modularization help manage complexity in large-scale digital systems.

---

# Lecture 4 (Part 1): Sequential Logic and Memory Elements

## From Combinational to Sequential

Unlike combinational logic, **sequential circuits** have outputs that depend on both current inputs and **past inputs** – in other words, they have memory. This capability is essential for building stateful systems such as counters, registers, and processors. Sequential circuits are the basis for storing data and controlling the flow of operations.

## Fundamental Storage: The Cross‑Coupled Inverter Pair

Two inverters connected in a loop (output of one connected to input of the other) create a bistable element with two stable states:

- State A: Q = 1, Q̅ = 0
- State B: Q = 0, Q̅ = 1

This forms the core of SRAM cells and latches. The circuit will stay in one state indefinitely unless forced to change.

## RS Latch (NAND Implementation)

- Inputs: **S** (set) and **R** (reset), both active low (because NAND gates are used).
- Outputs: Q and Q̅ (complementary).
- Truth table (S̅ and R̅ denote active-low inputs):
  - S̅ = 0, R̅ = 1 → Q = 1 (set)
  - S̅ = 1, R̅ = 0 → Q = 0 (reset)
  - S̅ = 1, R̅ = 1 → hold previous state
  - S̅ = 0, R̅ = 0 → forbidden, leads to **metastability** where Q = Q̅, an unstable condition.

## Gated D Latch

- Adds an enable signal (often called "write enable" or "clock") and a single data input D.
- When enable = 1, the latch is **transparent** – output Q follows D.
- When enable = 0, the latch holds its previous value (the last D before enable fell).
- Latches are **level‑sensitive** – they change output whenever enable is active, which can cause timing problems in complex systems (transparency window).

## Edge‑Triggered D Flip‑Flop

- Constructed by cascading two gated D latches with opposite clock phases (master-slave configuration).
- The output changes **only** on the edge of the clock (typically the rising edge).
- This provides a stable output during the entire clock cycle, making synchronous design possible.
- Why flip‑flops are preferred: They eliminate the transparency window and allow all state updates to happen simultaneously on the same clock edge, greatly simplifying timing analysis.

## Registers and Memory Arrays

- A **register** is a group of D flip‑flops sharing a common clock and enable, storing a multi‑bit value (e.g., 32-bit register).
- A **memory array** consists of many registers (words) plus:
  - An address decoder to select a word (read or write).
  - A multiplexer to read the selected word (read data).
  - Write enable logic combined with address decoder to write to one location at a time.
- Example: A 2‑location memory with 3‑bit wide data has a 1‑bit address, uses a 2‑to‑1 multiplexer for output, and a 1-to-2 decoder for write selection.

Memory can also implement arbitrary logic functions by storing the truth table and using inputs as address lines – this is exactly how FPGA lookup tables (LUTs) work.

---

# Lecture 4 (Part 2): Finite State Machines (FSMs) and FPGAs

## Finite State Machines – Definition and Purpose

An FSM is a mathematical model of a sequential system. It consists of:

- A finite number of **states** (e.g., idle, read, write, done).
- **Inputs** and **outputs**.
- **State transition logic** that determines the next state from the current state and inputs.
- **Output logic** that produces outputs based on the current state (and possibly inputs).

FSMs are used to design control logic in processors, communication protocols, traffic light controllers, and many other sequential systems.

## Moore vs. Mealy Machines

| Feature           | Moore Machine                        | Mealy Machine                        |
|-------------------|--------------------------------------|--------------------------------------|
| Output depends on | Current state only                   | Current state and inputs             |
| Timing            | Output changes after clock edge      | Output can change asynchronously with inputs |
| Number of states  | May require more states              | Often fewer states                    |
| Glitch sensitivity | Less prone to glitches               | More prone to glitches                |

In practice, Moore machines are more common in synchronous designs because they are easier to reason about and less sensitive to input glitches.

## FSM Design Process

1. **Specification** – describe the state‑dependent behavior in words.
2. **State diagram** – circles for states, arcs for transitions labeled with input/output.
3. **State transition table** – list current state, inputs, next state, outputs.
4. **State encoding** – assign binary codes to each state (choose encoding type).
5. **Logic minimization** – derive simplified Boolean equations for next state and outputs.
6. **Implementation** – use D flip‑flops for state register and combinational logic for next‑state and output functions.
7. **Verification** – simulate and test against the specification.

## State Encoding Techniques

- **Binary (fully encoded):** Uses `ceil(log2 N)` flip‑flops for \(N\) states. Minimizes flip‑flop count but may increase combinational logic complexity.
- **One‑hot:** Uses one flip‑flop per state (only one flip‑flop is 1 at any time). More flip‑flops, but next‑state logic becomes very simple (often just OR gates). One-hot is commonly used in FPGA designs.
- **Output encoding:** States are encoded such that the state bits directly serve as outputs. Useful for Moore machines when outputs are mutually exclusive.

## Synchronous Design Principles

- All state changes occur on the active clock edge (rising or falling).
- The clock period must be longer than the sum of:
  - Flip‑flop propagation delay (\(t_{pcq}\))
  - Worst‑case combinational logic delay (\(t_{pd}\))
  - Setup time (\(t_{setup}\))
- This constraint ensures that data arrives at the next flip‑flop before the next clock edge.
- Reset signals can be asynchronous (immediate) or synchronous (sampled with clock).

## FPGAs (Field‑Programmable Gate Arrays)

An FPGA is a reconfigurable integrated circuit that can implement arbitrary digital logic after manufacturing.

### Architecture Components
- **Lookup Tables (LUTs):** Small memories (e.g., 4‑input LUT, 6‑input LUT) that can implement any Boolean function. Each LUT is typically followed by a flip‑flop, making a configurable logic block (CLB).
- **Flip‑flops:** For sequential circuits; each CLB contains one or more flip‑flops.
- **Programmable interconnects:** Switch boxes and routing channels connect logic blocks.
- **I/O blocks:** Interface with external pins; configurable for different voltage standards.

### Advantages
- Reprogrammable – design can be updated without new fabrication.
- Fast prototyping – from idea to working hardware in hours or days.
- Specialization – can be optimized for specific algorithms (deep learning, cryptography).

### Disadvantages
- Slower and less power‑efficient than custom ASICs due to programmable switches.
- Larger area overhead.
- Higher per‑unit cost for high volume production.

### Applications
- Accelerating genomics and bioinformatics (DNA sequencing, protein folding).
- Machine learning inference engines.
- Network packet processing and security.
- Prototyping new processor architectures (e.g., DRAM research, RowHammer studies).
- Teaching digital design – the labs in this course use FPGA boards to implement a working MIPS microprocessor.

---

# Lecture 5: Hardware Description Languages and Verilog

## Why Use HDLs?

Modern chips contain billions of transistors. Drawing schematics manually is impossible. Hardware Description Languages (HDLs) like Verilog and VHDL allow designers to:

- **Describe hardware** at a higher level of abstraction (register-transfer level, RTL).
- **Simulate** the design to verify functionality before fabrication.
- **Synthesize** the description into a gate‑level netlist that can be placed and routed on an FPGA or ASIC.
- **Reuse** modules across projects through hierarchical design.
- **Model concurrency** naturally, unlike sequential programming languages.

## Verilog Basics

A Verilog design consists of **modules**. Each module has:

- A name.
- **Ports** – inputs, outputs, and bidirectional (inout) signals.
- Internal **wires** and **registers** (note: `reg` is a Verilog data type that can store a value; it does not necessarily synthesize to a hardware register).
- Behavior described using continuous assignments (`assign`) or procedural blocks (`always`).

### Module Declaration Example

```verilog
module mux2 (
    input wire a, b, sel,
    output wire y
);
    assign y = sel ? b : a;
endmodule
```

### Bit Vectors and Slicing
- Multi-bit signals declared with ranges: `input [31:0] a` (32-bit input, MSB = 31, LSB = 0).
- Slicing: `short_bus = long_bus[12:5];`
- Concatenation: `y = {a2, a1, a0, a0};`
- Duplication: `x = {4{a0}};`

### Numeric Literals
Format: `<size>'<base><value>`  
Examples: `8'b1010_1010`, `8'hAA`, `32'd42`, `4'b10xz`. Special digits: `x` (unknown), `z` (high impedance).

## Structural vs. Behavioral Modeling

- **Structural modeling:** Instantiates lower‑level modules or primitive gates (`and`, `or`, `not`, `xor`, etc.) and explicitly connects them. This mirrors the physical schematic. Good for hierarchy and design reuse.
- **Behavioral modeling:** Uses high‑level constructs like `assign`, `if`, `case`, arithmetic operators (`+`, `-`, `&`, `|`). The synthesis tool infers the hardware. Easier to write and maintain.

**Best practice:** Use behavioral modeling for simple, well‑defined functions (e.g., adders, multiplexers) and structural modeling for hierarchy and to instantiate complex submodules.

## Always Blocks and Sensitivity Lists

- **Combinational always block:** `always @(*)` – sensitivity to any change on the right‑hand side signals. Use for combinational logic that cannot be expressed with a simple `assign`.
- **Sequential always block:** `always @(posedge clk)` – triggered on the rising clock edge. Use for flip‑flops and registers.
- **Asynchronous reset:** `always @(posedge clk or negedge rst_n)` – resets immediately regardless of clock.

### Blocking vs. Non‑Blocking Assignments
- **Blocking (`=`):** Executes in order, like in a programming language. Use only in combinational `always` blocks or testbenches.
- **Non‑blocking (`<=`):** All assignments happen simultaneously at the end of the block. **Always use non‑blocking assignments for sequential logic (flip‑flops) to avoid race conditions.**

## Finite State Machine in Verilog (Three-Block Style)

- State register (sequential always)
- Next-state logic (combinational always with `case`)
- Output logic (combinational or sequential)
- States declared with `localparam` or `parameter`

## Synthesis and Simulation

- **Synthesis:** Converts Verilog into a netlist of gates and flip‑flops from a standard cell library, optimizing for area, speed, or power.
- **Simulation:** Executes the Verilog code in a simulator (e.g., ModelSim, Vivado Simulator) to check functional correctness. Timing can be added after synthesis.

## Good Coding Practices

- One module per file, file name matches module name.
- Use named port connections when instantiating modules (`.port(signal)`) – more readable and less error‑prone than ordered connections.
- Use consistent capitalization and naming conventions.
- Always think about the hardware that will be synthesized – avoid unintended latches by ensuring all `case` statements have a `default` and all assigned signals are set in all branches.
- Verify each module independently before integrating (unit testing).

---

# Lecture 6: Timing and Verification

## The Gap Between Ideal and Real

Digital abstraction assumes gates switch instantaneously. In reality, transistors have finite switching speeds, wires have resistance and capacitance, and signals propagate at finite speed. These physical effects introduce **delays** that must be accounted for.

## Combinational Circuit Delays

- **Contamination delay ($t_{cd}$):** The minimum time from an input change until the output **starts** to change. This depends on the shortest path through the circuit.
- **Propagation delay ($t_{pd}$):** The maximum time until the output **settles** to its final stable value. This depends on the longest path (critical path).

### Why Delays Vary
- Gate type (NAND vs. NOR, series vs. parallel transistors).
- Input pattern – some transitions are faster than others.
- Temperature and supply voltage.
- Manufacturing process variations.

## Glitches

Glitches are temporary, unwanted output transitions caused by unequal propagation delays along different paths. They increase dynamic power consumption and can cause functional errors if sampled during the glitch. Moore machines are less prone to glitches on outputs than Mealy machines.

## Sequential Circuit Timing Parameters

For a flip‑flop to operate correctly, the input data must satisfy two constraints relative to the clock edge:

- **Setup time ($t_{setup}$):** The minimum time before the active clock edge that data must be stable.
- **Hold time ($t_{hold}$):** The minimum time after the active clock edge that data must remain stable.

If setup or hold is violated, the flip‑flop may enter a **metastable** state where the output is unpredictable and can take arbitrarily long to settle.

### Clock‑to‑Q Delays
- ($t_{ccq}$) (contamination delay from clock to Q): the minimum time after the clock edge before Q changes.
- ($t_{pcq}$) (propagation delay from clock to Q): the maximum time until Q becomes valid.

## Timing Constraints Between Two Flip‑Flops

Consider a path from flip‑flop F1, through some combinational logic, to flip‑flop F2.

- **Setup constraint (maximum frequency):**  
 `T_clk >= t_pcq + t_pd,logic + t_setup`
- **Hold constraint:**  
  `t_ccq + t_cd,logic >= t_hold`

Hold violations are **independent of clock frequency** – they cannot be fixed by slowing down the clock. They must be fixed by adding delay buffers in the short path.

## Clock Skew

Clock signals do not arrive at all flip‑flops at exactly the same time due to wire delays and buffer mismatches. The difference is **clock skew**. Skew reduces timing margins and can cause both setup and hold violations. Clock distribution networks (e.g., H‑tree, clock mesh) are designed to minimize skew.

## Verification – Ensuring Correctness

Verification is the process of proving that a design meets its specification. It often consumes 50–70% of the total design effort.

### Levels of Verification
- **Functional verification:** Does the circuit compute the correct function? Done with simulation, formal methods, or hardware emulation.
- **Timing verification:** Does the circuit meet all setup and hold constraints? Done with static timing analysis (STA) or timing simulation.

### Simulation‑Based Verification
A **testbench** is a Verilog module that instantiates the Device Under Test (DUT), provides stimulus, and checks outputs.

Types of testbenches:
- **Simple (manual):** Manual inputs, manual output checking via waveforms.
- **Self-checking:** Manual inputs, automatic error detection using `$display` and `$error`.
- **Automatic (golden model):** Automatic input generation (e.g., random), comparison against a golden model.

### Golden Model
A golden model is a high‑level reference implementation (e.g., C++ function, Python script, or trusted behavioral Verilog) that is known to be correct. The testbench runs the same inputs on the DUT and golden model and compares results.

### The Input Space Problem
Exhaustive testing is impossible for most designs. For example, a 32‑bit adder has \(2^{64}\) possible input pairs. Solutions include:
- Directed tests for corner cases.
- Constrained random testing.
- Coverage metrics (line, toggle, FSM state coverage).
- Formal verification for small blocks.

### Static Timing Analysis (STA)
STA computes worst‑case delays through all paths without simulation. It is much faster than timing simulation and is used extensively in industry. However, STA assumes functional correctness; it does not verify logic function.

## Fixing Timing Violations

| Violation Type             | Fixes                                                                 |
|----------------------------|-----------------------------------------------------------------------|
| Setup (critical path too long) | Reduce combinational logic depth (pipeline), use faster gates, increase clock period. |
| Hold (short path too fast)     | Insert delay buffers, use flip‑flops with longer hold time, reduce clock skew. |

## Key Takeaways

- Real circuits have delays; the digital abstraction is an approximation.
- Setup and hold constraints determine maximum frequency and robustness.
- Hold violations are more serious because they cannot be fixed by slowing the clock.
- Clock skew reduces timing margins.
- Verification is essential and dominates design effort.
- STA is the primary timing verification method in industry.

---

# Unified Design Principles Across the Course

## Abstraction is Essential
Complex systems are manageable only through layered abstraction. From transistors to gates to modules to processors, each level hides unnecessary detail.

## Trade-offs are Everywhere
Every design decision balances performance, power, area, cost, reliability, security, and development time.

## Modularity Improves Productivity
Hierarchical design (top-down or bottom-up) simplifies implementation, testing, and reuse. Well-defined interfaces allow parallel work.

## Verification is Non-Negotiable
A correct design must be both functionally and temporally correct. Verification should be planned from the start.

## Hardware-Software Co-Design Matters
Future systems require optimization across the entire computing stack – from algorithms and programming models down to devices. Understanding hardware fundamentals enables better software and vice versa.

---

# Glossary of Key Terms

| Term                     | Definition                                                                 |
|--------------------------|----------------------------------------------------------------------------|
| Transistor (MOSFET)      | Voltage-controlled switch used to build logic gates.                      |
| NMOS/PMOS                | NMOS conducts at high gate voltage; PMOS at low gate voltage.             |
| CMOS                     | Complementary NMOS/PMOS technology for efficient logic.                   |
| NAND Gate                | Universal gate; output false only when all inputs true.                   |
| ISA                      | Instruction Set Architecture – contract between software and hardware.    |
| Microarchitecture        | Implementation of an ISA.                                                 |
| Combinational Circuit    | Output depends only on current inputs; no memory.                         |
| Sequential Circuit       | Output depends on current and past inputs; has memory.                    |
| Latch                    | Level-sensitive storage element.                                          |
| Flip-Flop                | Edge-triggered storage element.                                           |
| FSM                      | Finite State Machine – model of sequential behavior.                      |
| FPGA                     | Field-Programmable Gate Array – reconfigurable hardware.                  |
| Verilog                  | Hardware description language.                                            |
| Propagation Delay (\(t_{pd}\)) | Maximum time until output settles after input change.               |
| Contamination Delay (\(t_{cd}\)) | Minimum time before output starts changing.                         |
| Setup Time (\(t_{setup}\))     | Data stable before clock edge.                                        |
| Hold Time (\(t_{hold}\))       | Data stable after clock edge.                                         |
| Clock Skew               | Difference in clock arrival times at different flip-flops.                |
| Critical Path            | Longest delay path; limits maximum clock frequency.                       |
| Golden Model             | Reference model for automated verification.                               |

---

# Final Takeaways

- Digital systems are built from simple transistor switches that are abstracted as ON/OFF devices.
- Logic gates combine to form combinational circuits (decoders, multiplexers, adders) and sequential circuits (latches, flip-flops, registers).
- Sequential logic introduces memory, enabling stateful computation and finite state machines.
- FSMs provide a systematic framework for designing control logic; Moore machines are preferred for synchronous designs.
- FPGAs offer flexible, reconfigurable hardware platforms ideal for prototyping and acceleration.
- Verilog HDL enables scalable, modular hardware design with support for simulation and synthesis.
- Timing analysis (setup, hold, propagation, contamination, clock skew) ensures reliable operation in real hardware.
- Verification is as important as design itself, consuming the majority of effort in many projects.

Mastering these foundations provides the knowledge and skills required to design modern processors, accelerators, and complex digital systems. The course bridges the gap from device physics to system architecture, preparing students for both academic research and industry innovation.