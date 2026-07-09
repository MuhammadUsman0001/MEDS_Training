#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <simulation_log_file>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist"
    exit 1
fi

LOG_FILE="$1"

echo "Simulation Log Analysis: $LOG_FILE"

# Count with case-insensitive patterns
ERROR_COUNT=$(grep -c -i "error" "$LOG_FILE" 2>/dev/null || echo "0")
WARNING_COUNT=$(grep -c -i "warning" "$LOG_FILE" 2>/dev/null || echo "0")
PASS_COUNT=$(grep -c -i "pass" "$LOG_FILE" 2>/dev/null || echo "0")

# Also check for FAILED
FAIL_COUNT=$(grep -c -i "fail" "$LOG_FILE" 2>/dev/null || echo "0")

echo "ERRORs:   $ERROR_COUNT"
echo "WARNINGs: $WARNING_COUNT"
echo "PASSED:   $PASS_COUNT"
echo "FAILED:   $FAIL_COUNT"

# Exit with code 1 if any errors or failures found
if [ "$ERROR_COUNT" -gt 0 ] || [ "$FAIL_COUNT" -gt 0 ]; then
    echo "Simulation FAILED"
    exit 1
else
    echo "Simulation PASSED"
    exit 0
fi