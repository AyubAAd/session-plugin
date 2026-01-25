# Fix Session Context

Debug and troubleshooting. Need recent context and error info.

## Load Immediately

Extract from `.project/state.md`:
```bash
# Active focus and blockers
grep -A2 "## Active Focus" .project/state.md | tail -2
grep -A5 "## Blockers" .project/state.md | grep "^\-" | head -3
```

## Provide as Paths

- Most recent session: `ls -t .context/sessions/*.md | head -1`
- Feature spec if bug relates to a feature

## Gather Bug Context

Ask:
```
What's the issue?
- Error message?
- Steps to reproduce?
- When did it start?
```

## Based on Response

Read relevant source files based on error location.

If beads active and there's a bug task:
```bash
bd show <id>
```

## Ask

```
What's broken?
```
