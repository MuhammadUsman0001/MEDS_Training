# RISC-V "C" Extension Summary
## Compressed Instruction Set

### Overview

The "C" (Compressed) extension adds **16-bit compressed instructions** to the base 32-bit RISC-V ISA. These shorter encodings target the most commonly used operations and are freely mixed with standard 32-bit instructions in a program.

### What It Adds

The extension compresses instructions that typically use:
- **Small immediates** (numbers that fit in a few bits).
- **The zero register (`x0`)** or the **stack pointer (`x2`)**.
- **The most frequently used 8 registers** (`x8`–`x15`), as well as `x0`, `x1` (return address), and `x2` (stack pointer).
- **Short load/store offsets** (commonly used for accessing local variables on the stack).

### Why It Matters (Practical Applications)

The "C" extension is critical for real-world systems because it directly reduces **code size**, impacting memory cost and performance.

- **Reduces Code Size by ~25–30%**: On average, 50–60% of instructions in typical programs can be replaced with 16-bit versions, significantly shrinking binary size.
- **Saves Memory and Cost**: Smaller code allows the use of cheaper, smaller Flash or RAM, making it ideal for embedded and IoT devices.
- **Improves Cache Performance**: Smaller programs occupy less space in the Instruction Cache (I-Cache), reducing cache misses and improving execution speed and power efficiency.
- **Faster Instruction Fetch**: Fetching a 16-bit instruction takes half the bandwidth/time of a 32-bit one, boosting overall throughput, especially on simpler processor cores.