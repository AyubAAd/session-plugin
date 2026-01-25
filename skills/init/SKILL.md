---
description: Initialize session workflow structure with auto-detection. Analyzes existing codebase or guides new project setup. Use for first-time setup in any project.
---

# session:init

Initialize session workflow. For existing projects, analyzes codebase and pre-fills templates. For empty projects, asks what you're building and generates starter templates.

## Instructions

### 1. Check Existing Structure

```bash
ls -d .project .beads .context 2>/dev/null
```

If `.project/` exists, ask: Skip / Merge / Replace?

### 2. Detect Project State

```bash
ls -A | head -20
```

**If empty or only has .git:** → Go to [Empty Project Flow](#empty-project-flow)
**If has files:** → Go to [Existing Project Flow](#existing-project-flow)

---

## Empty Project Flow

### E1. Ask What They're Building

```
New project detected. What are you building?

1. Web App (frontend with React/Vue/Next.js)
2. API/Backend (Node/Python/Go/Rust)
3. CLI Tool
4. Library/Package
5. Full-Stack (frontend + backend)
6. Other (describe it)
```

### E2. Ask for Project Name and Description

```
What should we call this project? (short name)
Brief description? (1-2 sentences)
```

### E3. Generate Starter Templates

Based on selection, create `.project/` files with suggested stack:

| Type | Suggested Stack |
|------|-----------------|
| Web App | TypeScript, React/Next.js, Tailwind, Vitest |
| API/Backend | TypeScript/Python, Express/FastAPI, Jest/Pytest |
| CLI Tool | TypeScript/Rust, Commander/Clap |
| Library | TypeScript, Vitest, tsup for bundling |
| Full-Stack | TypeScript, Next.js or separate frontend/backend |

Create directories and templates (see [Create Directories](#3-create-directories) and templates below).

### E4. Report and Suggest Plan Session

```
Project initialized: {name}

Created .project/ with starter templates for {type}.
Stack suggestion: {suggested stack}

Next step: /session:start plan

In the plan session, you'll:
- Refine the project scope and architecture
- Define principles and constraints
- Break down into initial tasks
- Set your first focus area
```

**Stop here for empty projects.**

---

## Existing Project Flow

### 3. Analyze Codebase

#### Stack Detection

| File | Indicates |
|------|-----------|
| `package.json` | Node.js - read for framework/deps |
| `Cargo.toml` | Rust |
| `pyproject.toml` or `requirements.txt` | Python |
| `go.mod` | Go |
| `pom.xml` or `build.gradle` | Java |
| `Gemfile` | Ruby |
| `composer.json` | PHP |

#### Framework Detection (from package.json)

| Dependency | Framework |
|------------|-----------|
| `next` | Next.js |
| `react` | React |
| `vue` | Vue |
| `express` | Express |
| `fastify` | Fastify |
| `@angular/core` | Angular |
| `svelte` | Svelte |

#### Convention Detection

| File | Convention |
|------|------------|
| `tsconfig.json` | TypeScript |
| `.eslintrc*` | ESLint rules |
| `.prettierrc*` | Prettier formatting |
| `jest.config.*` | Jest testing |
| `vitest.config.*` | Vitest testing |
| `.github/workflows/` | GitHub Actions CI |

### 4. Create Directories

```bash
mkdir -p .project/features .context/{sessions,terminal,mcp}
```

### 5. Generate Pre-filled Templates

Use detected info to create populated templates.

#### .project/overview.md

```markdown
# Project Overview

## What is this?
[Detected: {framework} project with {structure}]
[TODO: Add 1-2 sentence description]

## Key Structure
{detected directory layout}

## Quick Start
```bash
{detected from package.json scripts.dev or scripts.start, or common patterns}
```

## Current Status
Active development
```

#### .project/stack.md

```markdown
# Tech Stack

## Core
- Language: {detected language}
- Framework: {detected framework}
- Runtime: {Node version from .nvmrc or engines, Python version, etc.}

## Key Dependencies
{top 5-10 dependencies with brief purpose if detectable}

## Dev Tools
- Linting: {eslint/prettier if detected}
- Testing: {jest/vitest/pytest if detected}
- CI: {GitHub Actions if .github/workflows exists}
```

#### .project/conventions.md

```markdown
# Conventions

## Code Style
{Detected from eslint/prettier config, or "See .eslintrc for rules"}

## TypeScript
{If tsconfig.json: "Strict mode enabled" or key settings}

## Testing
- Location: {tests/ or __tests__ or src/**/*.test.*}
- Framework: {detected test framework}

## Git
{If .github/workflows: "CI runs on PR"}
```

#### .project/constitution.md

```markdown
# Constitution

## Principles
- [TODO: Add non-negotiable principles]

## Non-Goals
- [TODO: What this project will NOT do]

## Constraints
- [TODO: Technical/business constraints]
```

#### .project/state.md

```markdown
# Current State

## Active Focus
[TODO: What are you working on?]

## Recent Decisions
- [TODO: Key decisions made]

## Blockers
- [ ] [TODO: Unresolved issues]

## Next Up
- [TODO: Upcoming work]

---
*Initialized: {date}*
```

### 6. Update .gitignore

Append if not present:
```
# Session workflow
.context/
```

### 7. Initialize beads

```bash
bd init 2>/dev/null || echo "beads not installed - task tracking disabled"
```

### 8. Report Results

```
Session initialized!

Detected:
  - Language: {language}
  - Framework: {framework}
  - Testing: {test framework}
  - CI: {GitHub Actions / none}

Created .project/ with pre-filled templates.
Created .context/ for session memory.
Initialized .beads/ for task tracking.

Next: Review .project/ files, then /session:start plan
```

---

## Shared Templates (Both Flows)

Both flows create the same file structure. For empty projects, use suggested values. For existing projects, use detected values.

#### .project/constitution.md (always needs user input)

```markdown
# Constitution

## Principles
- [Define in plan session]

## Non-Goals
- [Define in plan session]

## Constraints
- [Define in plan session]
```

#### .project/state.md

```markdown
# Current State

## Active Focus
{For empty: "Project setup and planning"}
{For existing: "[TODO: What are you working on?]"}

## Recent Decisions
- Initialized session workflow

## Blockers
- [ ] None yet

## Next Up
- Complete project planning

---
*Initialized: {date}*
```
