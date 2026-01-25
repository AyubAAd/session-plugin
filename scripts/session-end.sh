#!/bin/bash
# session-end.sh - Auto-save session closing info
# Only runs if project is opted-in (.context/ exists)

[ -d .context ] || exit 0

echo "session-workflow: Saving session closing info..."

# Read session_id from stdin JSON to find the correct session file
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
SHORT_ID=${SESSION_ID:0:8}

# Find session file matching this instance
if [ -n "$SHORT_ID" ]; then
    SESSION_FILE=$(ls -t .context/sessions/session_*_${SHORT_ID}.md 2>/dev/null | head -1)
fi

# Fallback to most recent if no match (backwards compatibility)
if [ -z "$SESSION_FILE" ]; then
    SESSION_FILE=$(ls -t .context/sessions/session_*.md 2>/dev/null | head -1)
fi

# Check for uncommitted work and remind user
if git rev-parse --git-dir > /dev/null 2>&1; then
    CHANGED=$(git diff --name-only 2>/dev/null)
    STAGED=$(git diff --staged --name-only 2>/dev/null)
    UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | head -5)

    if [ -n "$CHANGED" ] || [ -n "$STAGED" ] || [ -n "$UNTRACKED" ]; then
        echo ""
        echo "=== Uncommitted Work Reminder ==="
        if [ -n "$STAGED" ]; then
            echo "Staged files:"
            echo "$STAGED" | sed 's/^/  /'
        fi
        if [ -n "$CHANGED" ]; then
            echo "Modified files:"
            echo "$CHANGED" | sed 's/^/  /'
        fi
        if [ -n "$UNTRACKED" ]; then
            echo "Untracked files:"
            echo "$UNTRACKED" | sed 's/^/  /'
        fi
        echo ""
        echo "Consider committing before ending the session."
        echo ""
    fi
fi

# Remind about session closure
if [ -d .beads ]; then
    echo ""
    echo "=== Session Closure Reminder ==="
    echo "Before ending, consider running /session:end to:"
    echo "  - Close completed tasks (bd close)"
    echo "  - Create tasks for discovered work (bd create)"
    echo "  - Update current focus in .project/state.md"
    echo ""
fi

if [ -n "$SESSION_FILE" ]; then
    echo "" >> "$SESSION_FILE"
    echo "## Session Ended: $(date +"%Y-%m-%d %H:%M:%S")" >> "$SESSION_FILE"
    echo "" >> "$SESSION_FILE"
    echo "### Files Changed" >> "$SESSION_FILE"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        CHANGED=$(git diff --name-only 2>/dev/null)
        STAGED=$(git diff --staged --name-only 2>/dev/null)
        if [ -n "$CHANGED" ] || [ -n "$STAGED" ]; then
            [ -n "$STAGED" ] && echo "$STAGED" >> "$SESSION_FILE"
            [ -n "$CHANGED" ] && echo "$CHANGED" >> "$SESSION_FILE"
        else
            echo "No uncommitted changes" >> "$SESSION_FILE"
        fi
    else
        echo "Not a git repo" >> "$SESSION_FILE"
    fi

    echo "Session closing info appended to: $SESSION_FILE"
else
    echo "No session file found to update"
fi
