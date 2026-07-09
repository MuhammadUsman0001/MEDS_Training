#!/bin/bash

# Check argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' does not exist"
    exit 1
fi

TARGET_DIR="$1"
echo "Directory Statistics for: $TARGET_DIR"

# Total files
TOTAL_FILES=$(find "$TARGET_DIR" -type f | wc -l)
echo "Total files: $TOTAL_FILES"

# Total directories
TOTAL_DIRS=$(find "$TARGET_DIR" -type d | wc -l)
echo "Total directories: $TOTAL_DIRS"

# Largest file
LARGEST_FILE=$(find "$TARGET_DIR" -type f -exec du -b {} \; 2>/dev/null | sort -rn | head -1)
if [ -n "$LARGEST_FILE" ]; then
    LARGEST_SIZE=$(echo "$LARGEST_FILE" | cut -f1)
    LARGEST_NAME=$(echo "$LARGEST_FILE" | cut -f2)
    echo "Largest file: $LARGEST_NAME ($(numfmt --to=iec $LARGEST_SIZE))"
    #can also use :(for just showing bytes)
    #echo "Largest file: $LARGEST_NAME ($LARGEST_SIZE Bytes)"
fi

# Most recently modified
RECENT_FILE=$(find "$TARGET_DIR" -type f -printf "%T@ %p\n" 2>/dev/null | sort -rn | head -1)
if [ -n "$RECENT_FILE" ]; then
    RECENT_NAME=$(echo "$RECENT_FILE" | cut -d' ' -f2-)
    echo "Most recently modified: $RECENT_NAME"
fi