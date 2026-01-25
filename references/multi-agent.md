# Multi-Agent Context Patterns

When spawning sub-agents via Task tool, pass minimal context. Sub-agents can pull what they need.

## Principle

```
Pass:    IDs, paths, goals
Not:     Full content, dumps, "everything they might need"
```

Sub-agents have the same tools. They can `bd show`, `Read`, `Grep` as needed.

## Patterns

### Task-Based Work

```markdown
Implement task bd-a1b2.

Run `bd show bd-a1b2` for full details.
Key files: src/auth/login.ts, src/auth/types.ts
Conventions: .project/conventions.md
```

**Not:**
```markdown
Implement this task:
Title: Add login endpoint
Description: [50 lines of details]
Acceptance criteria: [20 lines]
Here's the current code: [200 lines]
Here are the conventions: [100 lines]
...
```

### Feature Implementation

```markdown
Implement Phase 2 of auth feature.

Spec: .project/features/auth/spec.md
Plan: .project/features/auth/plan.md (see Phase 2)
Related tasks: bd-a1b2, bd-c3d4
```

### Bug Fix

```markdown
Fix login timeout issue.

Error: "Connection timeout after 30s" in src/auth/client.ts:47
Recent change: git show abc123
Test: npm test -- --grep="login"
```

### Code Review

```markdown
Review changes in src/auth/.

Conventions: .project/conventions.md
Changed files: git diff --name-only HEAD~3
Focus: Security, error handling
```

## Anti-Patterns

| Don't | Do Instead |
|-------|------------|
| Paste full file contents | Provide file path |
| Include full task description | Provide task ID |
| Dump entire spec | Reference spec path + section |
| Pre-load "everything relevant" | Let agent pull what it needs |
| Explain project background | Agent reads .project/overview.md if needed |

## Context Budget

Sub-agent prompt should be **under 50 lines**:
- Goal: 1-2 lines
- Key references: 3-5 paths/IDs
- Specific focus: 1-2 lines
- Commands to run: 2-3 lines

The agent expands context as work demands it.

## Integration with Session Plugin

When ending a session that spawned sub-agents:
- Sub-agent work should update beads tasks (`bd close`, `bd update`)
- Main session captures summary, not sub-agent details
- Continuation file references completed work by task ID

## Example: Parallel Implementation

```markdown
# Main agent spawns 3 sub-agents

## Agent 1: Login endpoint
Task: bd-a1b2
Files: src/auth/login.ts
Test: npm test -- auth.login

## Agent 2: Logout endpoint
Task: bd-c3d4
Files: src/auth/logout.ts
Test: npm test -- auth.logout

## Agent 3: Token refresh
Task: bd-e5f6
Files: src/auth/refresh.ts
Test: npm test -- auth.refresh
```

Each agent gets ~5 lines of context, pulls the rest as needed.
