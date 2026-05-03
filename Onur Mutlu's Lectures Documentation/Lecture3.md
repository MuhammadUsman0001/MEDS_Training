## Onur Mutlu's Lecture 3 Summary

### Sequential Logic

This lecture covers advanced topics in **digital logic design**, focusing on combinational and sequential logic, memory structures, finite state machines (FSMs), and synchronization via clock signals. It builds on foundational knowledge of logic gates, programmable logic arrays (PLAs), and Boolean algebra, progressing towards practical circuit design and implementation concepts.

---

### Key Topics and Concepts

#### 1. **Combinational Logic Recap and Extensions**
- **Combinational logic** outputs depend solely on current inputs.
- Key building blocks revisited:
  - Basic logic gates, decoders, multiplexers (MUX), full adders, programmable logic arrays (PLA).
- **Programmable Logic Array (PLA):**
  - Implements any logic function via sum-of-products form.
  - Contains AND gates (decoder-like) and OR gates, programmable by connecting outputs of AND gates to OR gate inputs.
  - Demonstrated by implementing a **full adder**.
- **Logical Completeness:**
  - Sets of gates {AND, OR, NOT} are logically complete, meaning any logic function can be built using them.
  - NAND or NOR gates alone are also logically complete individually.
- **4-bit Equality Comparator:**
  - Uses bitwise XNOR gates to compare corresponding bits of two inputs.
  - Output is high only if all bits match (all XNOR outputs are 1).
- **Arithmetic Logic Unit (ALU):**
  - Combines arithmetic and logic operations.
  - Takes two $n$-bit inputs ($A$, $B$), a function selector $F$ (3 bits, allowing 8 functions).
  - Output depends on $F$, with internal multiplexers and an adder.
  - Examples include $Y = A + B$, $Y = A - B$ (2's complement subtraction), bitwise AND, OR, etc.
- **Tri-State Buffers:**
  - Act as switches controlled by an enable signal.
  - When enable=0, output is floating (disconnected).
  - Enable multiple devices to share a common bus without conflict.
  - Essential for shared communication buses in processors and memory.
- **Multiplexers (MUX) using Tri-State Buffers:**
  - 2-to-1 and 4-to-1 MUXes built with tri-state buffers controlled by select signals.
  - MUX select lines can be decoded internally.
- **Logic Simplification and Boolean Algebra:**
  - Simplification reduces gate count, latency, power consumption.
  - Electronic Design Automation (EDA) tools use Boolean algebra and the **uniting theorem** to minimize logic.
  - The uniting theorem helps eliminate variables that do not affect output in certain input combinations.
- **Priority Circuits:**
  - Manage multiple requests with static priority levels.
  - Only one requester is granted access at a time.
  - Truth tables incorporate "don't care" (X) states for simplification.

---

#### 2. **Sequential Logic and Memory Elements**

- **Sequential Logic:**
  - Outputs depend on current inputs and **past inputs** (memory).
  - Key for building circuits that **store state**.
- **Cross-Coupled Inverters:**
  - Fundamental bistable element with two stable states ($Q=1$, $\overline{Q}=0$ or vice versa).
  - Basis for latches and memory cells like SRAM.
- **RS Latch (NAND Gate Implementation):**
  - Adds control inputs $S$ (set) and $R$ (reset) to control $Q$.
  - Truth table:
    - $S=R=1$: hold previous state.
    - $S=0, R=1$: set $Q=1$.
    - $S=1, R=0$: reset $Q=0$.
    - $S=R=0$: forbidden, leads to **metastability** (invalid state where $Q = \overline{Q}$).
- **Gated D Latch:**
  - Adds write enable and data input $D$.
  - Only writes $D$ to $Q$ when write enable is active.
- **Registers:**
  - Parallel combinations of multiple D latches for storing multi-bit values.
  - Controlled by a single write enable signal.
- **Memory Arrays:**
  - Comprise multiple registers.
  - Address decoder selects which register to read/write.
  - Multiplexer selects output data from addressed register.
  - Write enable combined with address decoder allows writing to one location at a time.
  - Example: 2-location memory with 3-bit wide data and 1-bit address.
- **Logic Function Implementation Using Memory (Lookup Tables):**
  - Memory arrays can implement arbitrary logic by storing truth table outputs.
  - Used in FPGA LUTs for programmable logic.
  - Tradeoff: more hardware overhead compared to direct gate implementation but highly flexible.

---

#### 3. **Finite State Machines (FSMs) and Synchronization**

- **Definition:**
  - Discrete-time stateful systems.
  - States represent snapshots of system relevant information.
  - Inputs and outputs are finite sets.
  - Explicit transition and output logic.
- **Examples:**
  - Sequential lock: state transitions based on input sequence.
  - Traffic light controller: cyclic state transitions synchronized by clock.
- **Synchronous vs Asynchronous Circuits:**
  - **Synchronous:**
    - State transitions occur at fixed clock edges.
    - Easier to design, debug, and verify.
    - Clock signal synchronizes all sequential elements.
  - **Asynchronous:**
    - State transitions occur immediately upon input changes.
    - More efficient but complex and prone to race conditions.
- **Clock Signal:**
  - Oscillating signal cycling between 0 and 1.
  - Defines timing for state transitions in synchronous circuits.
  - Clock cycle duration must accommodate maximum combinational logic delay.
- **State Register Implementation:**
  - Need for storing current state stable during clock cycle.
  - Simple gated D latches are insufficient because they are level-sensitive and output changes during clock high.
- **Edge-Triggered D Flip-Flop:**
  - Constructed by cascading two gated D latches with inverted clock enables.
  - Changes output only at the **rising edge** of the clock.
  - Provides stable output throughout the clock cycle.
  - Essential building block for state storage in FSMs.
- **Register and Multi-bit Storage:**
  - Parallel arrays of flip-flops to store multi-bit states or data.
  - Notation: $Q[3:0]$ for 4-bit register outputs.

---

### Definitions and Comparisons Table

| Term                     | Definition                                                                                      | Notes                                                                                      |
|--------------------------|------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| **Programmable Logic Array (PLA)** | Hardware that implements arbitrary logic functions using AND-OR gates with programmable connections | Implements sum-of-products form; flexible but complex to program                          |
| **Tri-State Buffer**      | A buffer with an enable that outputs the input or disconnects (floating) the output             | Enables multiple devices to share a bus without conflict                                  |
| **Gated D Latch**         | A latch that stores data $D$ when enable is active                                             | Level sensitive; transparent when enabled                                                |
| **RS Latch (NAND version)** | Storage element with Set ($S$) and Reset ($R$) inputs controlling output $Q$                    | Forbidden state when $S=R=0$ leads to metastability                                      |
| **D Flip-Flop**           | Edge-triggered storage element that captures data only on clock rising edge                    | Built from two gated D latches with inverted clock enables                               |
| **Finite State Machine (FSM)** | Abstract model of a system with a finite number of states, transitions, inputs, and outputs     | Described by state diagrams; used to model sequential circuits                           |
| **Synchronous Circuit**   | Circuit where state changes happen only on clock edges                                        | Easier to design, requires clock distribution                                           |
| **Asynchronous Circuit**  | Circuit where state changes happen immediately upon input changes                             | More complex, prone to race conditions                                                  |

---

### Key Insights

- **Logical completeness of NAND and NOR gates** allows building any logic function from a single type of gate.
- **Tri-State buffers are crucial for bus architectures** enabling multiple devices to share communication lines safely.
- **Boolean algebra simplification and don’t-care conditions** are essential for efficient circuit design and are heavily leveraged by design automation tools.
- **RS latches illustrate foundational sequential logic but have forbidden states that cause instability**, leading to the development of gated latches and flip-flops.
- **Edge-triggered D flip-flops solve the problem of level-sensitive latches by synchronizing state changes with clock edges**, ensuring stable state throughout clock cycles.
- **Finite State Machines model sequential logic behavior** and are the basis for designing complex control systems.
- **Synchronous design paradigms dominate modern digital design** due to their relative ease of design and verification despite clock overhead.
- **Memory structures build on registers and decoders/multiplexers** enable scalable read/write operations essential for computing systems.
- **Lookup tables in FPGA architectures illustrate a tradeoff between hardware overhead and programmability**, highlighting the flexibility of memory-based logic implementations.

---

### Conclusion

This lecture provided a comprehensive overview of combinational logic extensions, the fundamentals of sequential logic and memory design, and introduced the critical concepts of synchronization and finite state machines in digital system design. The progression from basic gates to complex stateful systems emphasizes the interplay between logical abstraction and physical implementation, preparing learners for designing robust synchronous digital circuits.

---