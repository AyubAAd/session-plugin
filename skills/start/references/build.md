# Build Session Context

Implementation work. Need conventions and current task context.

## Load Immediately

Extract from `.project/state.md`:
```bash
# Active focus
grep -A2 "## Active Focus" .project/state.md | tail -2
```

## Determine Feature

1. Check if focus mentions a feature name
2. If unclear, ask: "Which feature?" and list:
   ```bash
   ls .project/features/ 2>/dev/null
   ```

## Provide as Paths (read on demand)

Once feature is known, tell user:
- `.project/conventions.md` - read when writing code
- `.project/features/{feature}/spec.md` - read when checking requirements
- `.project/features/{feature}/plan.md` - read when unsure what's next

Don't read these upfront. Claude reads when the implementation work demands it.

## Beads (if active)

Show ready task IDs:
```bash
bd ready --json --limit=3 2>/dev/null | jq -r '.[] | "\(.id): \(.title)"'
```

If user specifies a task, run `bd show <id>` to get full context.

## Ask

```
What are we building?
```

Or if task ID known:
```
Working on {id}. What's the approach?
```
