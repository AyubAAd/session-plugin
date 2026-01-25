# Review Session Context

Code review work. Need conventions and change history.

## Load Immediately

Nothing. Review is driven by what's being reviewed.

## Provide as Paths

- `.project/conventions.md` - read to check code against standards

## Determine Scope

Ask what to review:
```
What are we reviewing?
- PR number?
- Recent commits?
- Specific files?
```

## Based on Response

**For PR review:**
```bash
gh pr view <number> --json title,body,files
gh pr diff <number>
```

**For recent commits:**
```bash
git log --oneline -10
git diff HEAD~5..HEAD --stat
```

**For specific files:**
Read the files, then read `.project/conventions.md` to check against.

## Ask

```
What are we reviewing?
```
