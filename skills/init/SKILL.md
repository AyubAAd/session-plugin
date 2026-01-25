---
description: Initialize session workflow structure for a project
---

# session:init

Initialize the session workflow structure for a project, creating the three pillars: KNOWLEDGE (.project/), TASKS (.beads/), and MEMORY (.context/).

## Instructions

When the user runs `/session:init`, perform these steps:

### 1. Check Existing Structure

First, check what already exists:

```bash
ls -d .project .beads .context 2>/dev/null
```

If `.project/` already exists, ask if the user wants to:
- Skip (keep existing files)
- Merge (add missing files only)
- Replace (overwrite all)

### 2. Create .project/ Directory (KNOWLEDGE)

Create the project knowledge folder and all template files:

```bash
mkdir -p .project/features
```

#### Create .project/overview.md

```markdown
# Project Overview

## What is this?
[One paragraph: what the project does]

## Who is it for?
[Target users]

## Key Features
- [Feature 1]
- [Feature 2]

## Quick Start
[How to run locally]

## Current Status
[Active development / MVP / Production]
```

#### Create .project/constitution.md

```markdown
# Constitution

## Principles
- [Non-negotiable principle 1]
- [Non-negotiable principle 2]

## Non-Goals
- [What we will NOT build]
- [Scope boundaries]

## Constraints
- [Technical constraints]
- [Business constraints]
```

#### Create .project/stack.md

```markdown
# Tech Stack

## Core
- Language: [e.g., TypeScript]
- Framework: [e.g., Next.js]
- Database: [e.g., PostgreSQL]

## Key Dependencies
- [Dependency]: [What it's used for]

## Infrastructure
- Hosting: [e.g., Vercel]
- CI/CD: [e.g., GitHub Actions]
```

#### Create .project/conventions.md

```markdown
# Conventions

## Code Style
- [Style guide reference]
- [Key patterns]

## Naming
- Files: [convention]
- Components: [convention]
- Functions: [convention]

## Git Workflow
- Branch naming: [pattern]
- Commit format: [pattern]
- PR process: [description]

## Testing
- Unit tests: [where, how]
- Integration tests: [where, how]
```

#### Create .project/state.md

```markdown
# Current State

## Active Focus
[What we're working on now]

## Recent Decisions
- [Decision]: [Rationale]

## Blockers
- [ ] [Unresolved question or issue]

## Next Up
- [Next task or focus area]

---
*Last updated: [date] by init*
```

### 3. Create .context/ Directory (MEMORY)

Create the context management folders:

```bash
mkdir -p .context/{sessions,terminal,mcp}
```

These folders will store:
- `sessions/` - Session summary files (created during /session:start)
- `terminal/` - Large command outputs (auto-archived by hooks)
- `mcp/` - Large MCP tool outputs (auto-archived by hooks)

### 4. Update .gitignore

Add `.context/` to `.gitignore` (create if it doesn't exist):

```
# Session workflow - context management
.context/
```

Note: `.project/` should be tracked in git (it's project knowledge).
Note: `.beads/` tracking is managed by beads itself.

### 5. Initialize beads (TASKS)

Check if beads is already initialized:

```bash
ls -d .beads 2>/dev/null
```

If `.beads/` does not exist, initialize it:

```bash
bd init
```

If beads CLI is not available, inform the user:
"beads is not installed. Install it to enable task tracking, or skip this step."

### 6. Report What Was Created

Provide a summary of what was created:

```
Session Workflow initialized!

KNOWLEDGE (.project/)
  - overview.md      # What is this project
  - constitution.md  # Principles and non-goals
  - stack.md         # Tech stack and dependencies
  - conventions.md   # Code style and patterns
  - state.md         # Current focus and decisions
  - features/        # Feature specs and plans

MEMORY (.context/)
  - sessions/        # Session summaries
  - terminal/        # Large command outputs
  - mcp/             # Large MCP outputs

TASKS (.beads/)
  - [initialized / already exists / skipped]

Updated:
  - .gitignore       # Added .context/

Next steps:
1. Fill in .project/overview.md with your project description
2. Run /session:start plan to begin your first session
```

### 7. Offer to Help Fill Templates

Ask the user:
"Would you like me to help fill in the .project/ templates based on your codebase? I can analyze your project and draft initial content for overview.md, stack.md, and conventions.md."

If yes, analyze the project structure and help populate the templates.
