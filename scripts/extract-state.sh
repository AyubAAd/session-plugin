#!/bin/bash
# extract-state.sh - Pull specific sections from state.md
# Usage: extract-state.sh [focus|blockers|next|decisions|summary]

STATE_FILE=".project/state.md"
[ -f "$STATE_FILE" ] || exit 0

case "$1" in
    focus)
        # Just the active focus content (1-2 lines)
        grep -A2 "## Active Focus" "$STATE_FILE" | tail -n +2 | head -2 | sed '/^$/d'
        ;;
    blockers)
        # Blocker items only
        sed -n '/## Blockers/,/^##/p' "$STATE_FILE" | grep "^\- \[" | head -5
        ;;
    blocker-count)
        # Just the count
        grep -c "^\- \[ \]" "$STATE_FILE" 2>/dev/null || echo "0"
        ;;
    next)
        # Next up items
        sed -n '/## Next Up/,/^##/p' "$STATE_FILE" | grep "^\-" | head -3
        ;;
    decisions)
        # Recent decisions (last 3)
        sed -n '/## Recent Decisions/,/^##/p' "$STATE_FILE" | grep "^|" | grep -v "Decision\|---" | head -3
        ;;
    summary)
        # One-liner for orientation
        FOCUS=$(grep -A1 "## Active Focus" "$STATE_FILE" | tail -1 | head -c 60)
        BLOCKER_COUNT=$(grep -c "^\- \[ \]" "$STATE_FILE" 2>/dev/null || echo 0)
        if [ "$BLOCKER_COUNT" -gt 0 ]; then
            echo "Focus: $FOCUS | Blockers: $BLOCKER_COUNT"
        else
            echo "Focus: $FOCUS"
        fi
        ;;
    *)
        echo "Usage: extract-state.sh [focus|blockers|blocker-count|next|decisions|summary]"
        exit 1
        ;;
esac
