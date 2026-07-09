#!/bin/bash
set -euo pipefail

TOOLS=("bash" "grep" "awk" "sed")
MISSING=()

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING+=("$tool")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "Error: Missing tools: ${MISSING[*]}"
    echo "Install: sudo apt install ${MISSING[*]}"
    exit 1
fi

echo "OK: All dependencies found"
exit 0