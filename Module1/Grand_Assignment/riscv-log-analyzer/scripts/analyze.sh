#!/bin/bash
set -euo pipefail

LOG_FILE=""
FORMAT="text"
OUTPUT=""
VERBOSE=0

print_usage() {
    cat << EOF
Usage:
    ./analyze.sh <log_file> [OPTIONS]

OPTIONS:
    --format [text|csv]
    --output <file>
    --verbose
    --help
EOF
}

log_verbose() {
    if [ "$VERBOSE" -eq 1 ]; then
        echo "Info: $1"
    fi
}

if [ $# -lt 1 ]; then
    print_usage
    exit 1
fi

LOG_FILE="$1"
shift

while [ $# -gt 0 ]; do
    case "$1" in
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=1
            shift
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File not found"
    exit 1
fi

log_verbose "Analyzing log file"

# Use || true to avoid script exit when grep finds zero matches
TOTAL=$(grep -c "TEST START" "$LOG_FILE" 2>/dev/null || true)
PASS=$(grep -c "TEST PASS" "$LOG_FILE" 2>/dev/null || true)
FAIL=$(grep -c "TEST FAIL" "$LOG_FILE" 2>/dev/null || true)
SKIP=$(grep -c "TEST SKIP" "$LOG_FILE" 2>/dev/null || true)

if [ "$TOTAL" -eq 0 ]; then
    echo "Warning: No test start entries found in log file"
    TOTAL=1
fi

if [ "$TOTAL" -gt 0 ]; then
    PASS_RATE=$(awk "BEGIN {printf \"%.2f\", ($PASS/$TOTAL)*100}")
else
    PASS_RATE="0.00"
fi

# Pipeline may fail if no failed tests → add || true
FAILED_TESTS=$(grep "TEST FAIL" "$LOG_FILE" | sed 's/.*TEST FAIL: //' | cut -d' ' -f1 || true)
if [ -z "$FAILED_TESTS" ]; then
    FAILED_TESTS="None"
fi

# Pipeline may fail if no time data → add || true
TIMES=$(grep -E "TEST PASS|TEST FAIL" "$LOG_FILE" | sed -n 's/.*(\([0-9.]*\)s).*/\1/p' || true)

if [ -n "$TIMES" ]; then
    MIN_TIME=$(echo "$TIMES" | sort -n | head -1)
    MAX_TIME=$(echo "$TIMES" | sort -n | tail -1)
    AVG_TIME=$(echo "$TIMES" | awk '{sum+=$1} END {printf "%.2f", sum/NR}')
else
    MIN_TIME="N/A"
    MAX_TIME="N/A"
    AVG_TIME="N/A"
fi

if [ "$FORMAT" = "csv" ]; then
    REPORT="total,pass,fail,skip,pass_rate\n$TOTAL,$PASS,$FAIL,$SKIP,$PASS_RATE"
else
    REPORT=$(cat << EOF
=== RISC-V Simulation Log Analysis ===

Log file: $LOG_FILE

--- Results Summary ---
Total tests: $TOTAL
Passed: $PASS
Failed: $FAIL
Skipped: $SKIP
Pass rate: ${PASS_RATE}%

--- Failed Tests ---
$FAILED_TESTS

--- Timing Statistics ---
Min time: ${MIN_TIME}s
Max time: ${MAX_TIME}s
Avg time: ${AVG_TIME}s
EOF
)
fi

if [ -n "$OUTPUT" ]; then
    echo -e "$REPORT" > "$OUTPUT"
else
    echo -e "$REPORT"
fi