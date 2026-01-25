#!/bin/bash
# log-terminal.sh - Log large bash outputs (>50 lines)
# Only runs if project is opted-in (.context/terminal/ exists)

[ -d .context/terminal ] || exit 0

# Read tool output from stdin
OUTPUT=$(cat)

# Count lines
LINE_COUNT=$(echo "$OUTPUT" | wc -l | tr -d ' ')

# Only log if >50 lines
if [ "$LINE_COUNT" -gt 50 ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    LOG_FILE=".context/terminal/bash_${TIMESTAMP}.log"

    # Archive full output
    echo "$OUTPUT" > "$LOG_FILE"

    # Output truncated version: first 20 lines + last 10 lines
    echo "$OUTPUT" | head -20
    echo ""
    echo "... (${LINE_COUNT} lines total, $(( LINE_COUNT - 30 )) omitted) ..."
    echo "Full output archived: $LOG_FILE"
    echo ""
    echo "$OUTPUT" | tail -10
else
    # Small output: pass through unchanged
    echo "$OUTPUT"
fi
