#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <getopt.h>

// Simulated memory structure
typedef struct {
    uint8_t *data;      // pointer to allocated memory
    size_t size;        // total size in bytes
    uint32_t start_addr;// base address (logical start)
    int trace;          // flag: 1 = enable tracing, 0 = disable
} memory_t;

// Initialize memory: allocate and zero out
int memory_init(memory_t *mem, size_t size, uint32_t start_addr, int trace) {
    mem->data = (uint8_t*)calloc(size, 1);
    if (!mem->data) {
        fprintf(stderr, "Failed to allocate %zu bytes for memory\n", size);
        return -1;
    }
    mem->size = size;
    mem->start_addr = start_addr;
    mem->trace = trace;
    return 0;
}

// Write a byte (with optional trace)
void memory_write_byte(memory_t *mem, uint32_t addr, uint8_t value) {
    if (addr < mem->start_addr || addr >= mem->start_addr + mem->size) {
        fprintf(stderr, "Memory write out of bounds: 0x%08X\n", addr);
        return;
    }
    size_t offset = addr - mem->start_addr;
    if (mem->trace) {
        printf("TRACE: write byte 0x%02X to address 0x%08X (offset %zu)\n",
               value, addr, offset);
    }
    mem->data[offset] = value;
}

// Read a byte (with optional trace)
uint8_t memory_read_byte(memory_t *mem, uint32_t addr) {
    if (addr < mem->start_addr || addr >= mem->start_addr + mem->size) {
        fprintf(stderr, "Memory read out of bounds: 0x%08X\n", addr);
        return 0;
    }
    size_t offset = addr - mem->start_addr;
    if (mem->trace) {
        printf("TRACE: read byte 0x%02X from address 0x%08X (offset %zu)\n",
               mem->data[offset], addr, offset);
    }
    return mem->data[offset];
}

// Free memory
void memory_free(memory_t *mem) {
    if (mem->data) {
        free(mem->data);
        mem->data = NULL;
    }
}

// Print usage
void print_usage(const char *progname) {
    fprintf(stderr,
            "Usage: %s [OPTIONS]\n"
            "Options:\n"
            "  --mem-size <bytes>   Size of simulated memory (default: 65536)\n"
            "  --start-addr <addr>  Base address of memory (default: 0x00000000)\n"
            "  --trace              Enable memory access tracing (default: off)\n"
            "  --help               Show this help message\n",
            progname);
}

int main(int argc, char *argv[]) {
    // Default values
    size_t mem_size = 64 * 1024;      // 64 KB
    uint32_t start_addr = 0x00000000;
    int trace = 0;                     // disabled

    // Long option definitions
    static struct option long_options[] = {
        {"mem-size",   required_argument, 0, 's'},
        {"start-addr", required_argument, 0, 'a'},
        {"trace",      no_argument,       0, 't'},
        {"help",       no_argument,       0, 'h'},
        {0, 0, 0, 0}
    };

    int opt;
    int option_index = 0;
    while ((opt = getopt_long(argc, argv, "", long_options, &option_index)) != -1) {
        switch (opt) {
            case 's': // --mem-size
                mem_size = (size_t)strtoul(optarg, NULL, 0);
                if (mem_size == 0) {
                    fprintf(stderr, "Invalid mem-size: %s\n", optarg);
                    return EXIT_FAILURE;
                }
                break;
            case 'a': // --start-addr
                start_addr = (uint32_t)strtoul(optarg, NULL, 0);
                break;
            case 't': // --trace
                trace = 1;
                break;
            case 'h': // --help
                print_usage(argv[0]);
                return EXIT_SUCCESS;
            default:
                print_usage(argv[0]);
                return EXIT_FAILURE;
        }
    }

    // Any remaining arguments are errors
    if (optind < argc) {
        fprintf(stderr, "Unexpected extra arguments:\n");
        for (int i = optind; i < argc; i++)
            fprintf(stderr, "  %s\n", argv[i]);
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }

    // Initialize simulated memory
    memory_t mem;
    if (memory_init(&mem, mem_size, start_addr, trace) != 0) {
        return EXIT_FAILURE;
    }

    // Show configuration
    printf("Memory simulation configured:\n");
    printf("  Size       : %zu bytes (0x%zX)\n", mem.size, mem.size);
    printf("  Start addr : 0x%08X\n", mem.start_addr);
    printf("  Trace      : %s\n", mem.trace ? "ON" : "OFF");
    printf("  Address range: [0x%08X, 0x%08zX)\n",
           mem.start_addr, mem.start_addr + mem.size);
    printf("\n");

    // Demonstration: read/write few bytes
    uint32_t test_addr = start_addr + 0x100;
    memory_write_byte(&mem, test_addr, 0xAB);
    uint8_t val = memory_read_byte(&mem, test_addr);
    printf("Read back 0x%02X from 0x%08X\n", val, test_addr);

    // Out-of-bounds test (if trace is on, will show error)
    memory_write_byte(&mem, start_addr + mem.size, 0xFF);

    // Cleanup
    memory_free(&mem);
    return EXIT_SUCCESS;
}