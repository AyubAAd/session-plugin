---
name: session:start
description: >
  Start a typed session with progressive context loading. Use when beginning
  focused work on a project. Types: plan (design), build (implement),
  review (code review), fix (debug), document (docs). Loads minimal
  orientation context, pulls details on demand.
---

# session:start

Start a session with type-appropriate context. Load orientation, not information.

## Session Types

| Type | Purpose | Context |
|------|---------|---------|
| `plan` | Design work | overview, constitution, state |
| `build` | Implement | state, conventions, feature files |
| `review` | Code review | conventions, git history |
| `fix` | Debug | state, recent sessions |
| `document` | Update docs | overview, constitution |

## Instructions

### 1. Determine Type

If type not provided or invalid, ask:
```
Session type? [plan/build/review/fix/document]
```

### 2. Verify Structure

```bash
[ -d .project ] || echo "Run /session:init first"
```

### 3. Load Type-Specific Context

Read the appropriate reference file and follow its instructions:
- `plan` → Read [references/plan.md](references/plan.md)
- `build` → Read [references/build.md](references/build.md)
- `review` → Read [references/review.md](references/review.md)
- `fix` → Read [references/fix.md](references/fix.md)
- `document` → Read [references/document.md](references/document.md)

### 4. Create Session File

ID format: `{YYYY-MM-DD}-{type}-{3-random-chars}`

Create `.context/sessions/{id}.md`:
```markdown
# Session {date} ({type})

Goal: {user's goal}

Context loaded:
- {files loaded}

Progress:
- [ ] {goal as task}
```

### 5. Confirm and Begin

```
{TYPE} session started.
Focus: {from state.md if exists}
Session: .context/sessions/{id}.md

What are we working on?
```

## Progressive Disclosure Principle

Load ORIENTATION, not INFORMATION:
- Show file paths, not file contents (Claude reads when needed)
- Show task IDs, not full task details (use `bd show` when needed)
- Extract key sections from state.md, not the whole file

If beads is active, `bd prime` already loaded command reference. Don't duplicate.
