#!/bin/bash
# pre-compact.sh - Archive context before compaction
# Only runs if project is opted-in (.context/ exists)

[ -d .context ] || exit 0

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_FILE=".context/sessions/pre-compact_${TIMESTAMP}.md"

echo "session-workflow: Archiving context before compaction..."

# Find most recent session file
RECENT_SESSION=$(ls -t .context/sessions/session_*.md 2>/dev/null | head -1)

cat > "$ARCHIVE_FILE" << EOF
# Pre-Compaction Archive
Timestamp: $(date +"%Y-%m-%d %H:%M:%S")

## Active Session
${RECENT_SESSION:-"No active session file found"}

## Recent Terminal Logs
$(ls -lt .context/terminal/*.log 2>/dev/null | head -5 || echo "None")

## Recent MCP Archives
$(ls -lt .context/mcp/*.md 2>/dev/null | head -5 || echo "None")

## Recovery Instructions
After compaction, run \`/session:load-context\` to recover session state.
EOF

echo "Pre-compaction archive saved: $ARCHIVE_FILE"
