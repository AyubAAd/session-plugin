---
description: Lightweight ad-hoc task with minimal ceremony
---

# session:quick

Start a lightweight session for quick, ad-hoc tasks. Minimal context loading, no session file ceremony, quick summary on completion.

## When to Use

- Small one-off tasks that don't warrant a full session
- Quick fixes or tweaks
- Simple questions about the codebase
- Fast research or lookups
- Tasks expected to take < 15 minutes

## Instructions

When the user runs `/session:quick [task]`, perform these steps:

### 1. Verify Project Structure

Check if session workflow has been initialized:

```bash
ls -d .project 2>/dev/null
```

If `.project/` does not exist:
- Proceed anyway - quick sessions don't require full setup
- Just note: "No .project/ found, proceeding with minimal context"

### 2. Load Minimal Context

Extract only orientation from `.project/state.md`:

```bash
./scripts/extract-state.sh summary 2>/dev/null
```

This provides current focus and blocker count in one line.

**Do not load** full files unless specifically needed for the task.

### 3. Acknowledge Task

If a task was provided as an argument:
```
Quick session: {task}

Current focus: {from state.md Active Focus, or "unknown"}

Starting...
```

If no task was provided, ask:
```
Quick session mode. What do you need?
```

### 4. Execute Task

Work on the task directly:
- Keep it focused and efficient
- Don't create session files
- Don't do extensive context loading
- Ask clarifying questions only if essential

### 5. Quick Summary on Completion

When the task is complete, provide a brief summary:

```
Done!

What was done:
- {brief bullet points}

Files changed:
- {list any modified files, or "none"}
```

### 6. Optional State Update

If the quick task resulted in a significant change or decision:

Ask: "Should I note this in .project/state.md?"

If yes, add a brief entry to the "Recent Decisions" section:
```markdown
- [Brief decision]: [One-line rationale] (quick session)
```

Do **not** update Active Focus or other sections for quick tasks.

## What Quick Sessions Skip

- No session file creation in `.context/sessions/`
- No formal goal setting
- No extensive context loading
- No task status updates in beads (unless explicitly requested)
- No formal session end process

## Examples

### Example 1: Quick with task argument

```
User: /session:quick rename the Config interface to AppConfig

Assistant: Quick session: rename the Config interface to AppConfig

Current focus: Authentication feature

Starting...

[Searches for Config interface, renames to AppConfig across files]

Done!

What was done:
- Renamed Config interface to AppConfig
- Updated 12 imports across 8 files

Files changed:
- src/types/config.ts
- src/app.ts
- src/utils/settings.ts
- (and 5 more)
```

### Example 2: Quick without task argument

```
User: /session:quick

Assistant: Quick session mode. What do you need?

User: What database are we using?

Assistant: Let me check...

[Reads package.json and config files]

Done!

What was done:
- Identified database: PostgreSQL via Prisma ORM
- Connection configured in .env (DATABASE_URL)

Files changed:
- none
```

### Example 3: Quick task with state update

```
User: /session:quick add eslint rule to ban console.log in production code

Assistant: Quick session: add eslint rule to ban console.log in production code

Current focus: API refactoring

Starting...

[Updates .eslintrc.js to add no-console rule]

Done!

What was done:
- Added no-console rule to .eslintrc.js
- Set to error for production, warn for development

Files changed:
- .eslintrc.js

This changes your linting rules. Should I note this in .project/state.md?

User: yes

Assistant: Added to Recent Decisions in .project/state.md.
```

## Comparison: Quick vs Full Session

| Aspect | `/session:quick` | `/session:start` |
|--------|------------------|------------------|
| Context loaded | Only state.md | Type-specific files |
| Session file | None | Created in .context/sessions/ |
| Goal setting | Implicit from task | Explicitly asked |
| Task tracking | Skip | Integrated with beads |
| State update | Optional, minimal | Full update at end |
| Best for | < 15 min tasks | Focused work sessions |
