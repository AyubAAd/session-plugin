---
name: session:end
description: >
  End a session with task closure and state update. Captures work done,
  closes completed tasks, updates project state, writes continuation for
  next session. Use `/session:end quick` for fast close without review.
---

# session:end

Close session, capture work, update state for next session.

## Quick End (`/session:end quick`)

Fast close, minimal interaction:

```bash
git status --short 2>/dev/null
bd list --status=in_progress --json 2>/dev/null | jq -r '.[] | .id' | head -5
```

Write minimal continuation to `.context/continuation.md`:
```markdown
# Continue
Last: Quick end - no summary
In progress: {task IDs from above}
Ready: {bd ready --json --limit=3 | jq -r '.[].id'}
Suggested: /session:start build
```

Output:
```
Session closed (quick).
Uncommitted: {file count from git status}
In progress: {task IDs}
```

Done.

## Full End (`/session:end`)

### 1. Check Work Done

```bash
git status --short 2>/dev/null
```

If uncommitted changes, ask: "Commit before ending?"

### 2. Task Review (if beads active)

```bash
bd list --status=in_progress --json 2>/dev/null
```

For each task, ask: "Complete? (yes/no/partial)"
- **yes** → `bd close <id> --reason "completed"`
- **partial** → Note what remains, leave open
- **no** → Leave for next session

### 3. Discovered Work

Ask: "New tasks or issues discovered?"

If yes → See [references/discovered-work.md](references/discovered-work.md)

### 4. Update State

Update `.project/state.md`:
- **Active Focus**: Next priority
- **Recent Decisions**: Add any made this session (date, decision, rationale)
- **Blockers**: Add/remove as needed

### 5. Update Session File

Find current: `ls -t .context/sessions/*.md | head -1`

Append:
```markdown
## Summary
Completed: {what was done}
Closed: {task IDs}
Created: {new task IDs}
Carry forward: {next priorities}
Decisions: {key decisions made}
```

### 6. Write Continuation

Write `.context/continuation.md`:
```markdown
# Continue

Last: {1-2 sentence summary of session work}
Focus: {from updated state.md Active Focus}
Blockers: {count} {brief list if any}

In progress: {task IDs, comma-separated}
Ready: {top 3 task IDs from bd ready}

Suggested: /session:start {type}

Context: {key files or areas touched}
```

### 7. Final Output

```
Session ended.

Completed: {count} tasks
Created: {count} tasks
Focus: {next focus area}

Next: {top ready task or suggestion}

Files:
- Session: .context/sessions/{file}
- Continue: .context/continuation.md
```

## Output Quality Checklist

Before closing, ensure:
- [ ] All in-progress tasks addressed (closed, updated, or noted)
- [ ] State.md reflects current focus
- [ ] Continuation has enough context for cold start
- [ ] Session file captures decisions for future reference
