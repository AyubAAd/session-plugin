---
description: Initialize session workflow structure with auto-detection. Analyzes codebase to pre-fill project templates (stack, conventions, structure).
---

# session:init

Initialize session workflow with automatic project analysis. Creates three pillars (KNOWLEDGE, TASKS, MEMORY) and pre-fills templates based on detected stack and conventions.

## Instructions

### 1. Check Existing Structure

```bash
ls -d .project .beads .context 2>/dev/null
```

If `.project/` exists, ask: Skip / Merge / Replace?

### 2. Analyze Project (before creating files)

Detect stack, framework, and conventions by reading config files.

#### Stack Detection

Check these files (read only what exists):

| File | Indicates |
|------|-----------|
| `package.json` | Node.js - read for framework/deps |
| `Cargo.toml` | Rust |
| `pyproject.toml` or `requirements.txt` | Python |
| `go.mod` | Go |
| `pom.xml` or `build.gradle` | Java |
| `Gemfile` | Ruby |
| `composer.json` | PHP |

#### Framework Detection (from package.json dependencies)

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

#### Structure Detection

```bash
ls -d src lib app tests __tests__ docs .github 2>/dev/null
```

### 3. Create Directories

```bash
mkdir -p .project/features .context/{sessions,terminal,mcp}
```

### 4. Generate Pre-filled Templates

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

### 5. Update .gitignore

Append if not present:
```
# Session workflow
.context/
```

### 6. Initialize beads

```bash
bd init 2>/dev/null || echo "beads not installed - task tracking disabled"
```

### 7. Report Results

```
Session initialized with auto-detection!

Detected:
  - Language: {language}
  - Framework: {framework}
  - Testing: {test framework}
  - CI: {GitHub Actions / none}

Created:
  .project/
    overview.md     ← Review and refine
    stack.md        ← Detected, verify accuracy
    conventions.md  ← Detected from config files
    constitution.md ← TODO: Add principles
    state.md        ← TODO: Set current focus

  .context/         ← Session memory (gitignored)
  .beads/           ← Task tracking

Next: Review .project/ files, then /session:start plan
```

### 8. Offer Refinement

After creating files:
"I've pre-filled templates based on your codebase. Want me to read any .project/ file so you can refine it?"
