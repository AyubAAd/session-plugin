# Context Optimization

> Completed in v0.2.0

Progressive disclosure - load orientation, pull details on demand, maximize context for actual work.

## Results

| Metric | Before (0.1.0) | After (0.2.0) | Reduction |
|--------|----------------|---------------|-----------|
| Session hook (beads active) | ~40 lines | ~10 lines | 75% |
| Session hook (no beads) | ~25 lines | ~12 lines | 52% |
| `start/SKILL.md` | 303 lines | 83 lines | 73% |
| `end/SKILL.md` | 275 lines | 129 lines | 53% |
| Continuation file | ~30 lines | ~10 lines | 67% |
| **Total session start** | ~190 lines | ~50-60 lines | **~70%** |

---

## Problems Solved

### 1. Duplicate Context Loading (SOLVED)

**Was:** Both beads and session plugin taught beads commands. ~190 lines before work.

**Fix:** Session hook detects beads and skips command menu. Skills use IDs not tables.

### 2. Full File Loads (SOLVED)

**Was:** Loaded full state.md, conventions.md, spec.md upfront.

**Fix:** `extract-state.sh` pulls specific sections. Skills provide paths, not content.

### 3. Verbose Skills (SOLVED)

**Was:** 303-line start skill, 275-line end skill loaded every time.

**Fix:** Split by session type. Core skill ~80 lines, type-specific references ~30 lines each.

### 4. Push vs Pull (SOLVED)

**Was:** Push everything that *might* be needed.

**Now:** Push minimal orientation, Claude pulls what it *actually* needs.

---

## Design Principles

### Progressive Disclosure Layers

```
LAYER 0 - Always Present (unavoidable)
├── System prompt
├── Plugin skill definitions
└── Beads prime (if active)

LAYER 1 - Session Start (orientation only)
├── Project/feature name
├── Blocker count (not full list)
├── Ready task count + top 2-3 IDs
└── Suggested session type

LAYER 2 - Task Selection (when user picks work)
├── Full task details (bd show)
├── Related file paths (not content)
└── Acceptance criteria for THIS task

LAYER 3 - Implementation (pulled during work)
├── Source code (specific files)
├── Conventions (when writing code)
└── Spec sections (when checking requirements)

LAYER 4 - Session End (summary only)
├── What changed (file list)
├── Tasks completed (IDs)
└── Carry forward (1-2 sentences)
```

### The "Just Enough" Test

For each context load, ask:
1. Can Claude start working without this? → Don't load upfront
2. Will Claude definitely need this? → Load it
3. Might Claude need this? → Provide path, not content
4. Is this reference material? → Keep external, pull on demand

### Reference vs Inline Rule

| Scenario | Provide |
|----------|---------|
| "What should I work on?" | Task IDs + titles only |
| "Implement task X" | Full task details |
| "What are conventions?" | Path: `.project/conventions.md` |
| "Review this code" | Load conventions inline |

---

## Implementation Changes

### Phase 1: Fix Beads Overlap

#### 1.1 Detect Beads and Reduce Session Output

**File**: `scripts/session-start.sh`

```bash
#!/bin/bash
# session-start.sh - Minimal orientation, defer to beads if present

[ -d .project ] || exit 0

# If beads is active, it handles command reference via bd prime
# We only provide current state, not beads tutorials
BEADS_ACTIVE=false
[ -d .beads ] && BEADS_ACTIVE=true

echo "=== Session ==="

# Continuation context (always useful)
if [ -f .context/continuation.md ]; then
    # Extract just the summary, not full file
    SUMMARY=$(sed -n '/## Last Session Summary/,/^##/p' .context/continuation.md | grep -v "^##" | head -2)
    [ -n "$SUMMARY" ] && echo "Last: $SUMMARY"
fi

# Current focus (one line)
if [ -f .project/state.md ]; then
    FOCUS=$(grep -A1 "## Active Focus" .project/state.md | tail -1 | head -c 80)
    [ -n "$FOCUS" ] && echo "Focus: $FOCUS"
fi

# Blockers (count only, details on demand)
if [ -f .project/state.md ]; then
    BLOCKER_COUNT=$(grep -c "^\- \[ \]" .project/state.md 2>/dev/null || echo 0)
    [ "$BLOCKER_COUNT" -gt 0 ] && echo "Blockers: $BLOCKER_COUNT (see .project/state.md)"
fi

# Beads status (counts, not lists - beads prime teaches commands)
if [ "$BEADS_ACTIVE" = true ]; then
    READY=$(bd ready --json 2>/dev/null | jq 'length' 2>/dev/null || echo "?")
    IN_PROG=$(bd list --status=in_progress --json 2>/dev/null | jq 'length' 2>/dev/null || echo "?")
    echo "Tasks: $READY ready, $IN_PROG in progress"

    # Show top 2 ready task IDs only (not full table)
    TOP_READY=$(bd ready --json --limit=2 2>/dev/null | jq -r '.[] | .id' 2>/dev/null | tr '\n' ' ')
    [ -n "$TOP_READY" ] && echo "Next: $TOP_READY"
fi

# Minimal prompt (beads prime already shows commands if beads active)
if [ "$BEADS_ACTIVE" = false ]; then
    echo ""
    echo "Commands: /session:start, /session:quick, /session:end"
fi

echo ""
```

**Result**: ~10-15 lines instead of ~40

#### 1.2 Remove Beads Commands from Skills

**File**: `skills/start/SKILL.md`

Remove or reduce beads command examples. Replace with:

```markdown
### Beads Integration

If `.beads/` exists, beads is active. The `bd prime` hook loads command reference automatically.

- To see ready tasks: `bd ready`
- To see task details: `bd show <id>`

Do not duplicate beads documentation here.
```

---

### Phase 2: Slim Down Skills

#### 2.1 Split Skill by Session Type

**Current structure**:
```
skills/start/SKILL.md  (303 lines - all types in one file)
```

**New structure**:
```
skills/start/
├── SKILL.md           (50 lines - core logic + dispatch)
├── types/
│   ├── plan.md        (40 lines - plan-specific)
│   ├── build.md       (40 lines - build-specific)
│   ├── review.md      (30 lines - review-specific)
│   ├── fix.md         (30 lines - fix-specific)
│   └── document.md    (25 lines - document-specific)
```

**Core SKILL.md**:
```markdown
---
description: Start a typed session with progressive context loading
---

# session:start

## Instructions

1. Determine session type from argument or ask user
2. Read the type-specific instructions from `types/{type}.md`
3. Load MINIMAL context per those instructions
4. Create session file
5. Ask for session goal

## Session Types

| Type | Purpose | Context File |
|------|---------|--------------|
| plan | Design work | types/plan.md |
| build | Implement | types/build.md |
| review | Code review | types/review.md |
| fix | Debug | types/fix.md |
| document | Update docs | types/document.md |

## Context Loading Principle

Load ORIENTATION, not INFORMATION:
- Provide file paths, not file contents
- Show task IDs, not full task details
- Summarize state, don't dump files

Claude reads specific files when the work demands them.
```

#### 2.2 Rewrite Type-Specific Files

**Example**: `skills/start/types/build.md`

```markdown
# Build Session Context

## Load Immediately (orientation)
- `.project/state.md` - extract only:
  - Active Focus (1 line)
  - Blockers (list only)

## Provide as Paths (pull on demand)
- `.project/conventions.md` - read when writing code
- `.project/features/{feature}/spec.md` - read when checking requirements
- `.project/features/{feature}/plan.md` - read when unsure what's next

## Beads (if active)
Show ready task IDs. User or Claude runs `bd show <id>` for details.

## Session File
Create `.context/sessions/{date}-build-{id}.md` with:
- Timestamp
- Goal (ask user)
- Context paths loaded (not content)

## Start Prompt
```
Build session.
Focus: {from state.md}
Ready: {task IDs from bd ready --limit=3}

Conventions: .project/conventions.md
Spec: .project/features/{feature}/spec.md

What are we building?
```
```

---

### Phase 3: Summarize Instead of Dump

#### 3.1 State Extraction Helper

Create a script that extracts just what's needed from state.md:

**File**: `scripts/extract-state.sh`

```bash
#!/bin/bash
# extract-state.sh - Pull specific sections from state.md

STATE_FILE=".project/state.md"
[ -f "$STATE_FILE" ] || exit 0

case "$1" in
    focus)
        grep -A2 "## Active Focus" "$STATE_FILE" | tail -n +2 | head -2
        ;;
    blockers)
        sed -n '/## Blockers/,/^##/p' "$STATE_FILE" | grep "^\- \[" | head -5
        ;;
    next)
        sed -n '/## Next Up/,/^##/p' "$STATE_FILE" | grep "^\-" | head -3
        ;;
    summary)
        # One-liner for orientation
        FOCUS=$(grep -A1 "## Active Focus" "$STATE_FILE" | tail -1 | head -c 60)
        BLOCKER_COUNT=$(grep -c "^\- \[ \]" "$STATE_FILE" 2>/dev/null || echo 0)
        echo "Focus: $FOCUS | Blockers: $BLOCKER_COUNT"
        ;;
    *)
        echo "Usage: extract-state.sh [focus|blockers|next|summary]"
        ;;
esac
```

#### 3.2 Update Skills to Use Extraction

Instead of:
```markdown
Load `.project/state.md` (always)
```

Use:
```markdown
Run: `./scripts/extract-state.sh summary`
If blockers exist, run: `./scripts/extract-state.sh blockers`
```

---

### Phase 4: Continuation File Optimization

#### 4.1 Slim Continuation Format

**Current** `.context/continuation.md` (~30 lines):
```markdown
# Continuation Context

Last updated: 2025-01-25 14:30

## Last Session Summary
Implemented the login endpoint and started on refresh tokens.
Made decision to use RS256 for JWT signing.

## In Progress
- bd-a1b2: Add refresh token endpoint
- bd-c3d4: Implement logout

## Ready Tasks
- bd-e5f6: Add rate limiting
- bd-g7h8: Update API docs
- bd-i9j0: Add input validation

## Suggested Session Type
build - Implementation is ready

## Key Context
- Working in .project/features/auth/
- Using src/auth/ for implementation
- Tests in tests/auth/

## Blockers
- Waiting on Redis staging instance from DevOps
```

**Optimized** (~12 lines):
```markdown
# Continue

Last: Login endpoint done, started refresh tokens. Decided RS256 for JWT.
Focus: auth feature
Blockers: 1 (Redis staging)

In progress: bd-a1b2, bd-c3d4
Ready: bd-e5f6, bd-g7h8, bd-i9j0

Suggested: /session:start build

Files: .project/features/auth/, src/auth/, tests/auth/
```

The optimized version has the same information density but ~60% fewer tokens.

---

### Phase 5: Session End Optimization

#### 5.1 Quick vs Full End

**File**: `skills/end/SKILL.md`

Add clear quick path that's actually quick:

```markdown
## Quick End (`/session:end quick`)

1. Run: `git status --short` (show, don't process)
2. Run: `bd list --status=in_progress --json | jq -r '.[] | .id'` (IDs only)
3. Write to `.context/continuation.md`:
   ```
   # Continue
   Last: [Ask user for 1-sentence summary, or use "Quick end, no summary"]
   In progress: [task IDs from step 2]
   Ready: [bd ready --json --limit=3 | jq '.[] | .id']
   ```
4. Done. No interactive review.
```

#### 5.2 Full End Streamlined

Remove verbose examples. Focus on:
1. What changed (git status)
2. What's done (close tasks)
3. What's next (update continuation)

Skip:
- Detailed feature completion review (that's `/session:feature complete`)
- Extensive discovered work capture (do that during session)
- Long session file updates (session file is for reference, not narrative)

---

### Phase 6: Configuration

#### 6.1 Add Verbosity Setting

**File**: `.project/config.yaml` (user creates if needed)

```yaml
session:
  verbosity: minimal  # minimal | normal | verbose

  # What to show at session start
  show_menu: false      # Hide command menu for experienced users
  show_examples: false  # Hide example outputs in skills

  # Beads integration
  beads_in_hook: counts  # counts | list | none (if beads prime handles it)
```

#### 6.2 Update Scripts to Check Config

```bash
# In session-start.sh
CONFIG=".project/config.yaml"
VERBOSITY=$(grep "verbosity:" "$CONFIG" 2>/dev/null | awk '{print $2}' || echo "normal")

if [ "$VERBOSITY" = "minimal" ]; then
    # Ultra-compact output
    ...
fi
```

---

## Implementation Summary

### P0: Quick Wins - COMPLETE

| # | Task | Result |
|---|------|--------|
| 1 | Archive scripts | Truncate to head 20 + tail 10, archive full |
| 2 | Session hook | ~40 → ~10 lines (beads-aware) |
| 3 | extract-state.sh | Helper with focus/blockers/summary modes |
| 4 | Continuation format | ~30 → ~10 lines |

### P1: Skill Restructure - COMPLETE

| # | Task | Result |
|---|------|--------|
| 5 | start/SKILL.md | 303 → 83 lines + 5 reference files |
| 6 | end/SKILL.md | 275 → 129 lines with quick path |
| 7 | Beads audit | No duplication in remaining skills |

### P2: Beads Awareness - COMPLETE

Beads handles itself via `bd prime`. Session plugin:
- Makes beads apparent (init suggests it, skills reference commands)
- Doesn't duplicate beads functionality

### P3: Advanced - COMPLETE

| # | Task | Result |
|---|------|--------|
| 11 | Verbosity config | Skipped - minimal output is good default |
| 12 | Context awareness | Added `/session:status` skill |
| 13 | Multi-agent patterns | Added `references/multi-agent.md` |

---

## Final Metrics

All targets met or exceeded. See Results table at top of document.

---

## Reference: Context Budget Guidelines

| Stage | Budget | What Goes Here |
|-------|--------|----------------|
| Orientation (Layer 1) | 30-50 lines | Focus, blockers, ready IDs |
| Task Selection (Layer 2) | +20-30 lines | Selected task details |
| Implementation (Layer 3) | As needed | Source code, pulled on demand |
| Session End (Layer 4) | 10-20 lines | Summary, carry forward |
| **Total overhead** | **60-100 lines** | Everything except source code |

Everything else should be:
- A file path Claude can read if needed
- A command Claude can run if needed
- Pulled on demand, not pushed upfront
