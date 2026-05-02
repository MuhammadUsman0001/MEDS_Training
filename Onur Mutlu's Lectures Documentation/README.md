# Onur Mutlu's Digital Design and Computer Architecture — Lecture Summaries

## Lecture 1: Foundations — Transistors to Computer Architecture

### Core Ideas

* Computers are built hierarchically: **transistors → logic gates → circuits → processors → systems**.
* A transistor acts as a **digital switch**; CMOS combines **NMOS** and **PMOS** for efficient logic design.
* **NAND gates are universal**, meaning any digital circuit can be constructed from them.

### Architectural Perspective

* Computing spans multiple abstraction layers:

  **Problem → Algorithm → Program → System Software → ISA → Microarchitecture → Logic → Devices → Physics**

* **ISA** defines the hardware–software interface.

* **Microarchitecture** is the internal implementation of that ISA.

### Key Takeaways

* Modern systems are increasingly **heterogeneous**, integrating CPUs, GPUs, and specialized accelerators.
* Computer architecture is about balancing **performance, power, cost, reliability, and security**.
* Mastering fundamentals enables innovation across the hardware/software stack.

---

## Lecture 2: Combinational Logic Design

### Core Concepts

* **Combinational circuits** depend only on current inputs.
* Boolean algebra provides the mathematical foundation for logic design and optimization.
* Logic minimization reduces **area, delay, and power**.

### Essential Building Blocks

* **Decoders:** Convert encoded inputs into one-hot outputs.
* **Multiplexers (MUXes):** Select one input from many; also implement arbitrary logic functions.
* **Adders:** Perform binary arithmetic; ripple-carry adders illustrate hierarchical design.

### Power Insight

* Dynamic power dominates switching behavior:

  $$P_{dynamic} = C V^2 f$$

* Reducing voltage is the most effective way to lower power.

### Key Takeaways

* MUXes are universal logic elements and form the basis of FPGA LUTs.
* Digital design always involves trade-offs among **speed, power, area, and reliability**.

---

## Lecture 3–4: Sequential Logic and Finite State Machines

### Sequential Logic Fundamentals

* Sequential circuits depend on **current inputs and stored state**.

* Basic storage elements:

  * **Latches** (level-sensitive)
  * **Flip-flops** (edge-triggered)

* **D flip-flops** are preferred for synchronous design because they update only on clock edges.

### Finite State Machines (FSMs)

* Components:

  * **State Register**
  * **Next-State Logic**
  * **Output Logic**

* Types:

  * **Moore:** Output depends only on state
  * **Mealy:** Output depends on state and inputs

### Design Flow

1. Define states and transitions
2. Draw state diagram
3. Encode states
4. Derive logic equations
5. Implement with flip-flops and combinational logic
6. Simulate and verify

### Key Takeaways

* Synchronous design simplifies debugging and verification.
* FSMs are the foundation of digital control systems.
* Memory structures, controllers, and processors all rely on sequential logic.

---

## Lecture 4: FPGAs and Verilog Introduction

### FPGA Essentials

* FPGAs are **reconfigurable hardware platforms** composed of:

  * Lookup Tables (LUTs)
  * Programmable interconnects
  * I/O blocks

### Advantages and Trade-offs

* Fast prototyping and flexibility
* Lower performance and efficiency than ASICs
* Ideal for research, education, and specialized acceleration

### Verilog Basics

* Verilog describes hardware using **modules**.
* Supports **hierarchical**, **parallel**, and **modular** design.
* Enables simulation, synthesis, and implementation on FPGA/ASIC platforms.

### Key Takeaways

* Verilog bridges hardware concepts and real implementations.
* FPGAs are essential for rapid prototyping and hardware experimentation.

---

## Lecture 5: Verilog and Hardware Modeling

### Modeling Styles

* **Structural Modeling:** Gate/module interconnections
* **Behavioral Modeling:** Functional descriptions using operators and control statements

Most practical designs use a combination of both.

### Important Verilog Practices

* Use **non-blocking assignments (`<=`)** for sequential logic.
* Use **blocking assignments (`=`)** for combinational logic.
* Model combinational logic with `always @(*)`.
* Prefer **named port mapping** for readability and maintainability.

### Synthesis vs. Simulation

* **Simulation** verifies functionality.
* **Synthesis** converts HDL into optimized hardware.

### Key Takeaways

* Verilog is a hardware description language, not a traditional programming language.
* Always think about the hardware being generated.
* Verification should occur at every design level.

---

## Lecture 6: Timing and Verification

### Timing Fundamentals

* Real circuits are not instantaneous; delays arise from transistor switching and interconnect effects.

#### Key Delay Parameters

* **Propagation Delay ($t_{pd}$):** Maximum output settling time
* **Contamination Delay ($t_{cd}$):** Minimum time before output begins changing

### Sequential Timing Constraints

* Setup constraint:

  $$T_{clock} > t_{pcq} + t_{pd} + t_{setup}$$

* Hold constraint:

  $$t_{ccq} + t_{cd} > t_{hold}$$

* Hold violations require hardware fixes (e.g., added buffers).

### Critical Timing Concepts

* **Critical Path:** Determines maximum clock frequency
* **Clock Skew:** Difference in clock arrival times across registers
* **Metastability:** Result of setup/hold violations

### Verification Methodologies

* **Formal Verification:** Exhaustive but computationally expensive
* **Simulation-Based Verification:** Most widely used
* **Transistor-Level Simulation:** Highly accurate but slow

### Testbench Types

| Type          | Inputs    | Checking     |
| ------------- | --------- | ------------ |
| Simple        | Manual    | Manual       |
| Self-Checking | Manual    | Automatic    |
| Automatic     | Automatic | Golden Model |

### Key Takeaways

* Verification often consumes the majority of design effort.
* Both **functional correctness** and **timing correctness** are essential.
* Timing optimization is an iterative process involving synthesis, analysis, and refinement.

---

# Overall Course Themes

* Build systems from **transistors to processors**.
* Understand the interaction between **hardware, software, and algorithms**.
* Optimize across **performance, power, area, reliability, and security**.
* Use **Verilog, simulation, and FPGA prototyping** to transform concepts into working hardware.
* Design with both **correctness** and **timing** in mind.

---

# Essential Keywords

**CMOS, NAND, Boolean Algebra, MUX, Decoder, Flip-Flop, FSM, FPGA, Verilog, ISA, Microarchitecture, Critical Path, Setup Time, Hold Time, Clock Skew, Metastability, Testbench, Golden Model, Timing Verification**
