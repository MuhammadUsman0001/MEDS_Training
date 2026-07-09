#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "memory.h"

uint32_t *load_hex_file(const char *filename, size_t *num_instrs) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        perror("load_hex_file: fopen");
        return NULL;
    }

    uint32_t *data = NULL;
    size_t count = 0;
    char line[64];

    while (fgets(line, sizeof(line), fp)) {
        /* Skip empty lines and comments (lines starting with '#') */
        char *p = line;
        while (*p && isspace(*p)) p++;
        if (*p == '\0' || *p == '#')
            continue;

        unsigned long val;
        if (sscanf(p, "%lx", &val) != 1) {
            fprintf(stderr, "load_hex_file: parse error at line: %s", line);
            free(data);
            fclose(fp);
            return NULL;
        }

        uint32_t *new_data = realloc(data, (count + 1) * sizeof(uint32_t));
        if (!new_data) {
            perror("load_hex_file: realloc");
            free(data);
            fclose(fp);
            return NULL;
        }
        data = new_data;
        data[count++] = (uint32_t)val;
    }

    fclose(fp);
    *num_instrs = count;
    return data;
}
