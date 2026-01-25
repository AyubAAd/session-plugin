---
name: session:status
description: >
  Show current session context status. Use to see what's been loaded,
  files read, and outputs archived. Helps track context usage when
  terminal status bar isn't available.
---

# session:status

Show context awareness for current session.

## Instructions

### 1. Find Current Session

```bash
ls -t .context/sessions/*.md 2>/dev/null | head -1
```

### 2. Gather Context Info

**Session basics:**
```bash
# Session file
cat .context/sessions/session_*.md 2>/dev/null | head -20

# Session start time
grep "^# Session" .context/sessions/session_*.md | tail -1
```

**Archived outputs (context saved):**
```bash
# Terminal archives this session
ls -la .context/terminal/*.log 2>/dev/null | wc -l

# MCP archives this session
ls -la .context/mcp/*.md 2>/dev/null | wc -l
```

**Beads status (if active):**
```bash
bd list --status=in_progress --json 2>/dev/null | jq 'length'
bd ready --json 2>/dev/null | jq 'length'
```

### 3. Output Status

```
Session Status
==============

Session: .context/sessions/{file}
Started: {timestamp}
Type: {plan|build|fix|etc}

Context loaded:
  - Orientation: {from session file Context section}

Archived (saved from context):
  - Terminal outputs: {count} files
  - MCP responses: {count} files

Tasks:
  - In progress: {count}
  - Ready: {count}

Project:
  - Focus: {from state.md}
  - Blockers: {count}
```

### 4. Optional: Estimate Context Usage

If user asks for more detail:

```
Context Estimate
----------------
Session orientation: ~50 lines
Files read this session: (check conversation)
Archived outputs: {X} large outputs moved out of context

Tip: Large outputs (>50 lines) are auto-archived to .context/
```

## Quick Check

For fast status, just show:
```
Session: {type} | Tasks: {in_progress} active, {ready} ready | Archives: {count}
```
