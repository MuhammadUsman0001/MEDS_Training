#!/bin/bash

# Check arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <prefix> <suffix> <directory>"
    echo "Example: $0 alu cpu ./test_dir"
    exit 1
fi

PREFIX="$1"
SUFFIX="$2"
DIR="$3"

# Check directory
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist"
    exit 1
fi

cd "$DIR" || exit 1

echo "Renaming: ${PREFIX}_old_*.sv to ${SUFFIX}_new_*.sv"

COUNT=0
for file in ${PREFIX}_old_*.sv; do
    [ -f "$file" ] || continue
    
    # Extract number
    NUMBER=$(echo "$file" | sed "s/${PREFIX}_old_\([0-9]*\)\.sv/\1/")
    
    if [ -n "$NUMBER" ]; then
        NEWFILE="${SUFFIX}_new_${NUMBER}.sv"
        if [ ! -f "$NEWFILE" ]; then
            mv "$file" "$NEWFILE"
            echo "Renamed: $file to $NEWFILE"
            ((COUNT++))
        else
            echo "Warning: $NEWFILE already exists - skipping $file"
        fi
    fi
done

echo "Done! Renamed $COUNT files"