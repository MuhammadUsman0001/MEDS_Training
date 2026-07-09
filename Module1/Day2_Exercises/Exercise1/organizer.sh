#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Check directory exists
if [ ! -d "$1" ]; then
    echo "Directory not found"
    exit 1
fi

cd "$1"

for file in *; do
    [ -f "$file" ] || continue
    
    case "${file##*.}" in
        sv) mkdir -p verilog; mv "$file" verilog/ ;;
        c)  mkdir -p c_code;  mv "$file" c_code/ ;;
        txt) mkdir -p docs;   mv "$file" docs/ ;;
        *)  mkdir -p other;   mv "$file" other/ ;;
    esac
done

echo "Done!"