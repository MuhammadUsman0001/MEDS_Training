# Design Document – RISC-V Instruction Decoder

## Overview

The decoder reads a text file containing 32‑bit hexadecimal instructions,
decodes each according to the RISC‑V RV32I specification, and prints the
corresponding assembly mnemonic and operands.

## Key Design Decisions

1. **Separate decode and formatting** – `decode_instruction()` fills a
   `decoded_instr_t` structure, and `decode_to_asm()` converts it to a string.
   This separation allows easy extension to different output formats.

2. **Fixed-width integers** – All data types are from `<stdint.h>` to ensure
   predictable sizes on all platforms.

3. **Bit extraction macros** – `EXTRACT_BITS` and `SIGN_EXTEND` are used
   consistently, making the code readable and less error‑prone.

4. **Enumeration of opcodes** – All RV32I opcodes are defined as an `enum`,
   making the code self‑documenting and enabling compiler warnings on incomplete
   switch statements.

5. **Dynamic memory for hex loading** – The `load_hex_file()` function reads
   an arbitrary number of instructions and returns a dynamically allocated array.
   The caller is responsible for freeing it.

6. **Error handling** – The program checks for file existence, parse errors,
   and memory allocation failures, printing meaningful error messages.

7. **Makefile targets** – The build system supports debug, release, test, and
   Valgrind targets to simplify development.

## Extensibility

- New instruction types can be added by extending the `opcode_t` enum and the
  switch in `decode_instruction()`.
- The assembly formatter can be overridden by modifying `decode_to_asm()`.

## Testing

- Unit tests in `test/test_decoder.c` verify decoding of known instructions.
- Sample hex files (`test/programs/*.hex`) cover all major instruction classes:
  R‑type, I‑type (arithmetic and load), S‑type, B‑type, U‑type, and J‑type.
- `make test` runs both the unit tests and the decoder on all sample files.
