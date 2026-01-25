#!/bin/bash
# session-start.sh - Minimal orientation on startup
# Only runs if project is opted-in (.project/ exists)

[ -d .project ] || exit 0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BEADS_ACTIVE=false
[ -d .beads ] && BEADS_ACTIVE=true

echo "=== Session ==="

# Parse continuation file (supports both old and new format)
if [ -f .context/continuation.md ]; then
    # Try new lean format first (starts with "Last:")
    LAST=$(grep "^Last:" .context/continuation.md 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
    if [ -n "$LAST" ] && [ "$LAST" != "Quick end - no summary" ]; then
        echo "Last: $LAST"
    fi

    # Focus line
    FOCUS=$(grep "^Focus:" .context/continuation.md 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
    [ -n "$FOCUS" ] && echo "Focus: $FOCUS"

    # Blockers
    BLOCKERS=$(grep "^Blockers:" .context/continuation.md 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
    [ -n "$BLOCKERS" ] && [ "$BLOCKERS" != "0" ] && echo "Blockers: $BLOCKERS"

    # In progress (task IDs)
    IN_PROG=$(grep "^In progress:" .context/continuation.md 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
    [ -n "$IN_PROG" ] && echo "In progress: $IN_PROG"

    # Suggested session
    SUGGESTED=$(grep "^Suggested:" .context/continuation.md 2>/dev/null | cut -d: -f2- | sed 's/^ *//')
    [ -n "$SUGGESTED" ] && echo "Suggested: $SUGGESTED"

    # Fall back to old format if new format didn't match
    if [ -z "$LAST" ]; then
        OLD_SUMMARY=$(sed -n '/## Last Session Summary/,/^##/p' .context/continuation.md 2>/dev/null | grep -v "^##" | head -1 | sed '/^$/d')
        [ -n "$OLD_SUMMARY" ] && echo "Last: $OLD_SUMMARY"
    fi
else
    # No continuation file - extract from state.md
    if [ -f .project/state.md ]; then
        "$SCRIPT_DIR/extract-state.sh" summary 2>/dev/null
    fi
fi

echo ""

# Beads status - counts and IDs only (bd prime handles command reference)
if [ "$BEADS_ACTIVE" = true ]; then
    READY_COUNT=$(bd ready --json 2>/dev/null | jq 'length' 2>/dev/null || echo "?")
    IN_PROG_COUNT=$(bd list --status=in_progress --json 2>/dev/null | jq 'length' 2>/dev/null || echo "?")

    echo "Tasks: $READY_COUNT ready, $IN_PROG_COUNT in progress"

    # Show top 3 ready task IDs only (not full table)
    TOP_READY=$(bd ready --json --limit=3 2>/dev/null | jq -r '.[] | .id' 2>/dev/null | tr '\n' ' ')
    [ -n "$TOP_READY" ] && echo "Ready: $TOP_READY"
    echo ""
fi

# Only show menu if beads is NOT active (bd prime shows commands if beads is active)
if [ "$BEADS_ACTIVE" = false ]; then
    echo "Commands: /session:start [plan|build|fix], /session:quick, /session:end"
    echo ""
fi

# Create session file
if [ -d .context ]; then
    INPUT=$(cat)
    SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
    SHORT_ID=${SESSION_ID:0:8}

    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    if [ -n "$SHORT_ID" ]; then
        SESSION_FILE=".context/sessions/session_${TIMESTAMP}_${SHORT_ID}.md"
    else
        SESSION_FILE=".context/sessions/session_${TIMESTAMP}.md"
    fi
    mkdir -p .context/sessions

    cat > "$SESSION_FILE" << EOF
# Session $(date +"%Y-%m-%d %H:%M")

Type: pending
Goal: pending

Context:
- (updated by /session:start)

Notes:

EOF

    echo "Session: $SESSION_FILE"
fi
