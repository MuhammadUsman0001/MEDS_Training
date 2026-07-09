
# RISC-V Privileged Architecture Summary
## Based on RISC-V Privileged Spec (Volume 2), Sections 3.1–3.4 (Machine-Level ISA)

### Privilege Levels

The RISC-V privileged architecture defines up to three privilege levels, with **Machine Mode (M-mode)** being the highest and mandatory. M-mode has unrestricted access to the hardware and is the first mode entered at reset. The text focuses on M-mode's control and status registers (CSRs) and the trap handling flow.

### Key Machine-Level CSRs

M-mode uses specific Control and Status Registers (CSRs) to manage the processor:

| CSR | Full Name & Function |
| :--- | :--- |
| **`misa`** | **Machine ISA Register**. Reports which standard extensions (e.g., A, C, D, F, M, V) the hardware supports. |
| **`mstatus`** | **Machine Status Register**. The master control register. Tracks the current privilege level, globally enables/disables interrupts, and manages the interrupt-enable stack. |
| **`mtvec`** | **Machine Trap-Vector Base-Address Register**. Holds the base address of the trap handler. When an exception or interrupt occurs, the CPU jumps to this address. |
| **`mepc`** | **Machine Exception Program Counter**. Saves the address of the interrupted instruction so the handler can resume execution later. |
| **`mcause`** | **Machine Cause Register**. Indicates the reason for the trap. The highest bit distinguishes interrupts (1) from exceptions (0); the lower bits provide the specific cause code. |
| **`mtval`** | **Machine Trap Value Register**. Provides additional trap information, such as a faulty memory address or an illegal instruction encoding. |
| **`mip` / `mie`** | **Machine Interrupt Pending / Enable Registers**. `mip` shows pending interrupts, while `mie` controls which interrupts are allowed to trigger. |

### Trap Handling Flow

When an interrupt or exception occurs in M-mode, the hardware executes the following strict sequence:

1.  **Save the PC**: The current Program Counter (PC) is saved into the **`mepc`** register.
2.  **Record the Cause**: The trap reason is written into **`mcause`**; additional info is stored in **`mtval`**.
3.  **Disable Interrupts**: The global interrupt enable bit (`MIE`) in **`mstatus`** is cleared to prevent nested interrupts.
4.  **Jump to Handler**: The CPU sets the PC to the address stored in **`mtvec`**, starting execution in the trap handler.
5.  **Handle the Trap**: The handler reads `mcause` and `mtval` to determine the appropriate action (e.g., service a device, emulate an instruction, or terminate a faulty process).
6.  **Return (MRET)**: The handler executes **`MRET`**, which restores the PC from `mepc`, re-enables interrupts using `mstatus`, and returns control to the interrupted program.