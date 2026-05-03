## Onur Mutlu's Lecture 4 Summary

### Sequential Logic, Finite State Machines, FPGAs, and Verilog Introduction

This lecture continues the discussion of **sequential logic design** and **finite state machines (FSMs)**, transitioning into hardware description languages (HDLs) with an emphasis on **Verilog**. It also introduces practical lab work involving **FPGA (Field Programmable Gate Array)** platforms.

---

### Core Concepts and Key Insights

#### 1. Sequential Logic and Finite State Machines Recap
- **Sequential circuits** produce outputs based on **current inputs and past states**, embodying the concept of **memory**.
- FSMs are discrete time models with:
  - A **finite number of states**, inputs, and outputs.
  - Explicit **state transitions** determined by inputs and current state.
  - Defined **output logic** that depends on the current state or both state and inputs.
- FSM components:
  - **State Register:** Stores the current state.
  - **Next State Logic:** Determines the next state from the current state and inputs.
  - **Output Logic:** Produces outputs based on current state and possibly inputs.

- **Edge-triggered D flip-flops** are used for state registers to ensure:
  - State changes occur only on clock edges.
  - Outputs remain stable during the clock cycle.
- Latches are **level-triggered and transparent**, which can cause unintended state changes.

#### 2. Example FSM: Smart Traffic Light Controller
- Controls two avenues (A and B) with traffic sensors as inputs.
- Traffic lights have three states: **Red, Yellow, Green**.
- Light states change every 5 seconds unless traffic is detected on the green-lit avenue (which causes the light to stay green).
- This FSM is a **Moore machine** since outputs depend only on the current state.
- Drawbacks include **lack of fairness** as one avenue may be green indefinitely if traffic persists.

#### 3. FSM Design Process
- Construct a **state transition diagram** with states as circles and transitions as arcs.
- Develop a **state transition table** based on inputs and current states.
- Encode states using binary (minimum bits to represent states, e.g., 2 bits for 4 states).
- Convert the table to Boolean expressions for the **next state** and **output logic**.
- Simplify Boolean expressions using logic theorems (e.g., sum of products, uniting theorem).
- Implement the state register with D flip-flops and connect to logic circuits.

#### 4. Timing and Practical Considerations
- Timing diagrams illustrate how state transitions occur at clock edges.
- **Clock cycle duration** must accommodate the **delay of combinational logic** to ensure correct operation.
- If the clock cycle is too short, incorrect states or outputs may result.
- Reset signals are often **asynchronous**, forcing the FSM to a known initial state immediately.

#### 5. State Encoding Techniques
| Encoding Type            | Description                                                                 | Pros                          | Cons                              |
|-------------------------|-----------------------------------------------------------------------------|-------------------------------|----------------------------------|
| **Fully (Binary) Encoded**  | Minimum bits used ($\lceil \log_2 n \rceil$ for $n$ states).                 | Minimizes flip-flops           | More complex next-state logic     |
| **One-Hot Encoding**        | Each state represented by a flip-flop bit; only one bit is 'hot' at a time.  | Simplifies next-state logic    | Maximizes number of flip-flops    |
| **Output Encoding**          | States encode output directly (useful for Moore machines).                   | Minimizes output logic         | Complexity in next-state logic    |

#### 6. Moore vs. Mealy Machines
- **Moore machine:** Output depends only on the current state.
- **Mealy machine:** Output depends on current state and inputs.
- Mealy machines can reduce the number of states but increase output logic complexity.

#### 7. FSM as Programs
- FSM design is analogous to programming with conditionals and state transitions.
- FSMs are widely used to model control logic in hardware, such as instruction decoding, execution control, and accelerator units.
- Large hardware systems consist of many interacting FSMs.

---

### FPGAs

#### FPGA Overview
- **FPGA**: Field Programmable Gate Arrays are **reconfigurable hardware chips** allowing implementation of custom circuits.
- Composed of:
  - **Look-Up Tables (LUTs):** Implement combinational logic.
  - **Switch Boxes:** Configure interconnections between logic blocks.
  - **I/O Blocks:** Interface with external peripherals.
- Advantages:
  - High specialization and energy efficiency.
  - Reusability and short development time.
- Disadvantages:
  - Not as fast or power-efficient as custom ASICs.
  - Overheads in area, latency, and reliability due to reconfigurability.
  
#### FPGA Applications
- Used in diverse fields such as:
  - Deep learning acceleration.
  - DNA sequencing and genomics.
  - Weather prediction.
  - Bioinformatics accelerators.
- Example projects:
  - **DRAM Bender:** FPGA-based infrastructure for DRAM experimental studies.
  - Research on **Row Hammer** and **Row Press** effects in DRAM reliability.

---

### Hardware Description Language (HDL) and Verilog Introduction

#### Motivation for HDLs
- Modern chips have billions of transistors (e.g., Apple M1 Ultra with 114B transistors).
- Manually designing at transistor/gate level is infeasible.
- HDLs allow:
  - **Hierarchical modular design** of complex hardware.
  - **Simulation** of functional and timing behavior.
  - **Synthesis** into hardware (mapped onto FPGA or ASIC).
- HDLs support **parallelism and concurrency** inherent in hardware, unlike sequential programming languages.

#### Verilog Basics
- Main building block: **module**.
- Module definition includes:
  - Module name.
  - Port declaration (inputs, outputs).
  - Functionality description.
- Multi-bit signals are declared with ranges, e.g., $$input [31:0] a$$ for a 32-bit input.
- Hierarchical design allows:
  - Top-down approach: Define system modules and submodules.
  - Bottom-up approach: Build complex modules from primitives (gates, multiplexers, adders).
- Verilog supports various styles of port declarations and modular definitions.

---

### Timeline Table (Process of FSM Design to Implementation)

| Step                         | Description                                                                                   |
|------------------------------|-----------------------------------------------------------------------------------------------|
| 1. Define FSM specification   | Identify states, inputs, outputs, transitions.                                               |
| 2. Draw state transition diagram | Visualize states and transitions.                                                            |
| 3. Develop transition and output tables | Tabulate next state and output values for all input/state combinations.                    |
| 4. State encoding             | Assign binary codes to states (fully encoded, one-hot, or output encoding).                   |
| 5. Logic simplification       | Minimize Boolean expressions for next state and output logic.                                |
| 6. Implement state registers  | Use D flip-flops for edge-triggered state storage.                                           |
| 7. Implement combinational logic | Use gates or programmable logic blocks for next state and output logic.                     |
| 8. Timing analysis            | Ensure clock cycle accommodates combinational logic delays.                                  |
| 9. Simulate and verify        | Validate functional correctness via timing diagrams and test benches.                        |
| 10. Synthesize and deploy     | Use CAT tools to map design onto FPGA or ASIC.                                               |

---

### Key Definitions and Comparisons

| Term                  | Definition                                                                                     |
|-----------------------|------------------------------------------------------------------------------------------------|
| **Sequential Circuit** | Circuit whose output depends on current and past inputs; has memory elements.                  |
| **Combinational Circuit** | Circuit whose output depends only on current inputs; no memory elements.                      |
| **D Flip-Flop**        | Edge-triggered memory element capturing input at clock edge, holding value stable during cycle.|
| **Latch**              | Level-triggered memory element; transparent when enabled, causing possible timing issues.      |
| **Moore Machine**      | FSM where outputs depend only on the current state.                                            |
| **Mealy Machine**      | FSM where outputs depend on current state and current inputs.                                  |
| **FPGA**               | Reconfigurable integrated circuit composed of LUTs, switches, and I/O blocks.                  |
| **Verilog HDL**        | Hardware description language used for modeling and synthesizing digital circuits.             |

---

### Summary of Important Technical Points

- **Edge-triggered D flip-flops** are essential for synchronous FSMs to avoid transparency problems of latches.
- FSM outputs can be encoded in different ways, each with trade-offs between hardware cost and complexity.
- Timing constraints are critical: the clock period must be longer than the sum of the longest combinational logic delay plus setup time.
- FSM design parallels programming but operates on concurrent logic rather than sequential instructions.
- FPGAs provide flexible, reconfigurable hardware platforms ideal for prototyping and accelerating specialized applications.
- Verilog enables design abstraction from gates to complex systems via modular, hierarchical code.

---

### Concluding Remarks

This lecture bridges theoretical concepts of sequential logic and FSM design with practical hardware implementation on FPGAs and the use of HDLs like Verilog. The material prepares students for hands-on labs that progressively build towards designing a functional 32-bit MIPS microprocessor, emphasizing both **conceptual understanding** and **practical skills** in modern digital design.

---