#!/bin/bash

# Image OCR Script
# Extracts text from images/screenshots using macOS Vision framework via AppleScript
# No UI required - pure scripting solution
# https://stackoverflow.com/questions/71104893/macos-how-to-access-the-live-text-ocr-functionality-from-applescript-jxa

if [ $# -eq 0 ]; then
    echo "Usage: $0 <image-file>"
    echo "Example: $0 screenshot.png"
    exit 1
fi

FILE="$1"

# Check if file exists
if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' does not exist"
    exit 1
fi

# Convert to absolute path (required for AppleScript)
ABS_FILE=$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
APPLESCRIPT_FILE="${SCRIPT_DIR}/../applescripts/image-ocr.applescript"

# Check if AppleScript file exists
if [ ! -f "$APPLESCRIPT_FILE" ]; then
    echo "Error: AppleScript file not found: $APPLESCRIPT_FILE" >&2
    exit 1
fi

# Run the AppleScript using Vision framework and capture output
EXTRACTED_TEXT=$(osascript "$APPLESCRIPT_FILE" "$ABS_FILE")

EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    if [ -n "$EXTRACTED_TEXT" ]; then
        echo "$EXTRACTED_TEXT"
    else
        echo "No text found in image: $FILE"
    fi
else
    echo "Error: OCR failed for: $FILE" >&2
    exit 1
fi

