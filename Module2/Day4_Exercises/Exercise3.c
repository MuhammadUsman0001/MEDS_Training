#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1000

int main(int argc, char *argv[]) {
    // Check command-line argument
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <logfile>\n", argv[0]);
        return EXIT_FAILURE;
    }

    const char *filename = argv[1];
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) {
        fprintf(stderr, "Error: Could not open file '%s'\n", filename);
        perror("fopen");  // Shows system error (e.g., No such file)
        return EXIT_FAILURE;
    }

    char line[MAX_LINE];
    int pass = 0, fail = 0, skip = 0;

    // Read line by line
    while (fgets(line, sizeof(line), fp) != NULL) {
        if (strstr(line, "TEST PASS:") != NULL) {
            pass++;
        } else if (strstr(line, "TEST FAIL:") != NULL) {
            fail++;
        } else if (strstr(line, "TEST SKIP:") != NULL) {
            skip++;
        }
        // Ignore other lines (START, ERROR, summary, etc.)
    }

    fclose(fp);

    // Calculate total tests
    int total = pass + fail + skip;
    printf("SUMMARY: %d tests, %d passed, %d failed, %d skipped\n",
           total, pass, fail, skip);

    return EXIT_SUCCESS;
}