# Plan Session Context

Design and architecture work. Heavy on project knowledge, light on implementation details.

## Load Immediately

Extract from `.project/state.md` (not full file):
```bash
# Active focus only
grep -A2 "## Active Focus" .project/state.md | tail -2
# Blocker count
grep -c "^\- \[ \]" .project/state.md 2>/dev/null || echo "0"
```

## Provide as Paths (read on demand)

Tell user these are available:
- `.project/overview.md` - project description, goals
- `.project/constitution.md` - principles, constraints, non-goals
- `.project/features/` - existing feature specs

Read these only when the planning work requires them.

## Beads (if active)

Show count and top IDs only:
```bash
bd list --status=open --json 2>/dev/null | jq '{total: length, top: .[0:3] | map(.id)}'
```

Don't dump full task list. User runs `bd show <id>` for details.

## Feature Creation

If user wants to start a new feature:
```
To create a feature with spec and plan:
/session:feature create <name>
```

## Ask

```
What are we planning?
```
