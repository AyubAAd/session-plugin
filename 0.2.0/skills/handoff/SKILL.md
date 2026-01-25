---
description: Generate a continuation prompt for a new chat session
---

# session:handoff

Generate a copy-pasteable continuation prompt for starting a new chat session with full context.

## Instructions

When the user runs `/session:handoff`, generate a handoff prompt that can be pasted into a new Claude session.

### 1. Gather Current Context

Collect information from multiple sources:

```bash
# Get project info
cat .project/state.md 2>/dev/null

# Get continuation info if available  
cat .context/continuation.md 2>/dev/null

# Get in-progress tasks
bd list --status=in_progress 2>/dev/null

# Get ready tasks
bd ready --limit=5 2>/dev/null

# Get recent git activity
git log --oneline -5 2>/dev/null
```

### 2. Generate Handoff Prompt

Create a structured prompt in this format:

```markdown
Continue developing [project name].

Project: [absolute path]
Repo: [git remote URL if available]

## Context
[Read ARCHITECTURE.md or relevant docs for design decisions]
[Key files or components being worked on]

## Ready Tasks (run `bd ready` to verify)
- [task-id]: [title]

## This Session's Work
[Brief summary of what was accomplished]

## Suggested Next Steps
1. [Most important next action]
2. [Secondary action]

Use subagents for parallel implementation where possible.
```

### 3. Output Format

Present the handoff prompt in a copyable format:

```
=== HANDOFF PROMPT (copy below this line) ===

[Generated prompt content]

=== END HANDOFF PROMPT ===
```

### 4. Options

- `/session:handoff --focus="X"` - Focus on specific feature
- `/session:handoff --minimal` - Shorter prompt with essentials only
- `/session:handoff --files` - Include recently modified files

## Example

```
User: /session:handoff
Assistant: Generating handoff prompt...

=== HANDOFF PROMPT (copy below this line) ===

Continue developing my-project.

Project: /path/to/my-project
Repo: https://github.com/user/my-project

## Context
Read ARCHITECTURE.md for design decisions.
Currently implementing user authentication.

## Ready Tasks (run `bd ready` to verify)
- v2-abc: Add login endpoint
- v2-def: Create auth middleware

## This Session's Work
1. Set up project structure
2. Implemented basic routing

## Suggested Next Steps
1. Complete login endpoint (v2-abc)
2. Add session management

Use subagents for parallel implementation where possible.

=== END HANDOFF PROMPT ===
```

