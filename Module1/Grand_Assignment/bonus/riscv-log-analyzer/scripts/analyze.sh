#!/bin/bash
set -euo pipefail

LOG_FILE=""
FORMAT="text"
OUTPUT=""
VERBOSE=0
COMPARE_FILE=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

print_usage() {
cat << EOF
Usage:
  ./analyze.sh <log_file> [options]

Options:
  -f, --format [text|csv]
  -o, --output <file>
  -c, --compare <log_file>
  -v, --verbose
  -h, --help
EOF
}

log() {
    [ "$VERBOSE" -eq 1 ] && echo "[INFO] $*"
}

count_tests() { grep -c "TEST START" "$1" || true; }
count_pass()  { grep -c "TEST PASS" "$1" || true; }
count_fail()  { grep -c "TEST FAIL" "$1" || true; }
count_skip()  { grep -c "TEST SKIP" "$1" || true; }

extract_results() {
    grep "TEST" "$1" | awk '{print $4 " " $5}' | sort || true
}

compare_logs() {
    echo "=== REGRESSION DIFF ==="
    diff <(extract_results "$1") <(extract_results "$2") || true
}

if [ $# -lt 1 ]; then
    print_usage
    exit 1
fi

LOG_FILE="$1"
shift

while getopts ":f:o:c:vh-:" opt; do
    case "$opt" in
        f) FORMAT="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        c) COMPARE_FILE="$OPTARG" ;;
        v) VERBOSE=1 ;;
        h) print_usage; exit 0 ;;
        -)
            case "${OPTARG}" in
                format) FORMAT="${!OPTIND}"; OPTIND=$((OPTIND+1)) ;;
                output) OUTPUT="${!OPTIND}"; OPTIND=$((OPTIND+1)) ;;
                compare) COMPARE_FILE="${!OPTIND}"; OPTIND=$((OPTIND+1)) ;;
                verbose) VERBOSE=1 ;;
                help) print_usage; exit 0 ;;
                *) echo "Invalid option"; exit 1 ;;
            esac
        ;;
        *) echo "Invalid option"; exit 1 ;;
    esac
done

[ ! -f "$LOG_FILE" ] && echo "Error: file not found" && exit 1

if [ -n "$COMPARE_FILE" ]; then
    compare_logs "$LOG_FILE" "$COMPARE_FILE"
    exit 0
fi

TOTAL=$(count_tests "$LOG_FILE")
PASS=$(count_pass "$LOG_FILE")
FAIL=$(count_fail "$LOG_FILE")
SKIP=$(count_skip "$LOG_FILE")

[ "$TOTAL" -eq 0 ] && TOTAL=1

PASS_RATE=$(awk "BEGIN {printf \"%.2f\", ($PASS/$TOTAL)*100}")

FAILED_TESTS=$(grep "TEST FAIL" "$LOG_FILE" | sed 's/.*TEST FAIL: //' | cut -d' ' -f1 || true)

if [ "$FORMAT" = "csv" ]; then
    REPORT="total,pass,fail,skip,pass_rate\n$TOTAL,$PASS,$FAIL,$SKIP,$PASS_RATE"
else
    REPORT=$(cat <<EOF
=== RISC-V Log Analysis ===
File: $LOG_FILE

Total: $TOTAL
Pass: $PASS
Fail: $FAIL
Skip: $SKIP
Pass Rate: ${PASS_RATE}%

Failed Tests:
$FAILED_TESTS
EOF
)
fi

if [ -n "$OUTPUT" ]; then
    echo -e "$REPORT" > "$OUTPUT"
else
    echo -e "$REPORT"
fi

if [ "$FAIL" -gt 0 ]; then
    echo -e "${RED}Some tests failed${RESET}"
    exit 1
else
    echo -e "${GREEN}All tests passed${RESET}"
    exit 0
fi