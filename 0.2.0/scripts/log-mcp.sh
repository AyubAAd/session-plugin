#!/bin/bash
# log-mcp.sh - Log large MCP responses (>50 lines)
# Only runs if project is opted-in (.context/mcp/ exists)

[ -d .context/mcp ] || exit 0

# Read tool output from stdin
OUTPUT=$(cat)

# Count lines
LINE_COUNT=$(echo "$OUTPUT" | wc -l | tr -d ' ')

# Only log if >50 lines
if [ "$LINE_COUNT" -gt 50 ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    # Try to get tool name from environment, fallback to generic
    TOOL_NAME="${TOOL_NAME:-mcp_response}"
    TOOL_NAME=$(echo "$TOOL_NAME" | tr '/:' '_')

    LOG_FILE=".context/mcp/${TOOL_NAME}_${TIMESTAMP}.md"

    # Archive full output
    cat > "$LOG_FILE" << EOF
# MCP Response Archive
Tool: ${TOOL_NAME}
Timestamp: $(date +"%Y-%m-%d %H:%M:%S")
Lines: ${LINE_COUNT}

## Response
\`\`\`
${OUTPUT}
\`\`\`
EOF

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
