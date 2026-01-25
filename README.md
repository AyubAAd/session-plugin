```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   ███████╗███████╗███████╗███████╗██╗ ██████╗ ███╗   ██╗        │
│   ██╔════╝██╔════╝██╔════╝██╔════╝██║██╔═══██╗████╗  ██║        │
│   ███████╗█████╗  ███████╗███████╗██║██║   ██║██╔██╗ ██║        │
│   ╚════██║██╔══╝  ╚════██║╚════██║██║██║   ██║██║╚██╗██║        │
│   ███████║███████╗███████║███████║██║╚██████╔╝██║ ╚████║        │
│   ╚══════╝╚══════╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝        │
│                                                                 │
│   Context-lean session management for AI-assisted development   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

# Session Workflow Plugin

Orchestrates multi-session work with progressive disclosure - load orientation, pull details on demand.

## Features

- **Typed sessions** - plan, build, review, fix, document
- **Progressive disclosure** - minimal upfront context, expand as needed
- **Three-pillar structure** - Knowledge (.project/), Memory (.context/), Tasks (.beads/)
- **Beads integration** - Git-backed task tracking with dependencies
- **Context optimization** - ~70% reduction in context overhead vs naive loading

## Installation

Add the plugin marketplace and install:

```bash
/plugin marketplace add gh33k/session-plugin
/plugin install session
```

Or install directly from GitHub:

```bash
/plugin install gh33k/session-plugin
```

## Quick Start

```bash
# Initialize in your project
/session:init

# Start a session
/session:start build

# Quick ad-hoc task
/session:quick fix the typo in login.ts

# End session
/session:end
```

## Commands

| Command | Purpose |
|---------|---------|
| `/session:init` | Initialize three-pillar structure |
| `/session:start <type>` | Start typed session (plan/build/review/fix/document) |
| `/session:end` | End session, update state, write continuation |
| `/session:end quick` | Fast close without review |
| `/session:quick [task]` | Lightweight ad-hoc task |
| `/session:feature create <name>` | Create feature spec and plan |
| `/session:feature complete <name>` | Mark feature complete |
| `/session:handoff` | Generate prompt for new chat session |
| `/session:status` | Show context awareness |

## Project Structure

After `/session:init`:

```
your-project/
├── .project/           # KNOWLEDGE (version controlled)
│   ├── overview.md     # What is this project
│   ├── constitution.md # Principles and constraints
│   ├── stack.md        # Tech stack
│   ├── conventions.md  # Code style and patterns
│   ├── state.md        # Current focus and decisions
│   └── features/       # Feature specs and plans
│
├── .context/           # MEMORY (gitignored)
│   ├── sessions/       # Session summaries
│   ├── terminal/       # Archived large outputs
│   ├── mcp/            # Archived MCP responses
│   └── continuation.md # Context for next session
│
└── .beads/             # TASKS (managed by beads)
```

## Session Types

| Type | Purpose | Context Loaded |
|------|---------|----------------|
| `plan` | Design work, architecture | overview, constitution, state |
| `build` | Implementation | state, conventions, feature files |
| `review` | Code review | conventions, git history |
| `fix` | Debugging | state, recent sessions |
| `document` | Documentation | overview, constitution |

## Development Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   PLAN ──────► BUILD ──────► REVIEW ──────► DOCUMENT            │
│     │           │              │                                │
│     │           ▼              │                                │
│     │         FIX ◄────────────┘                                │
│     │           │                                               │
│     └───────────┴──► (repeat for next feature)                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Typical Flow

1. **Plan** - Start with `/session:start plan`
   - Design the feature, break down into tasks
   - Create feature spec: `/session:feature create auth`
   - Tasks created in beads with dependencies

2. **Build** - Switch to `/session:start build`
   - Pick a ready task: `bd ready`
   - Implement, commit, close task: `bd close <id>`
   - Repeat until feature complete

3. **Review** - Run `/session:start review`
   - Check code against conventions
   - Verify acceptance criteria
   - Note issues for fix session if needed

4. **Fix** - If issues found: `/session:start fix`
   - Debug and resolve
   - Return to review when fixed

5. **Document** - Wrap up with `/session:start document`
   - Update README, API docs
   - Mark feature complete: `/session:feature complete auth`

### Session Lifecycle

```
/session:start <type>    Start focused work
       │
       ▼
    [work]               Context pulled as needed
       │
       ▼
/session:end             Capture state, update continuation
       │
       ▼
   [new chat]            /session:handoff if needed
       │
       ▼
/session:start           Continue where you left off
```

Each session is self-contained. State persists via `.context/continuation.md` and beads tasks.

## Context Philosophy

**Load orientation, not information.**

- Show file paths, not file contents
- Show task IDs, not full task details
- Extract key sections, not full files
- Pull details when work demands them

### Progressive Disclosure Layers

```
Layer 0: Always present (system prompt, plugin definitions)
Layer 1: Session start (focus, blockers, ready task IDs)
Layer 2: Task selection (full task details when picked)
Layer 3: Implementation (source code as needed)
Layer 4: Session end (summary only)
```

## Beads Integration

This plugin works with [beads](https://github.com/steveyegge/beads) for task tracking. If beads is installed:

- `/session:init` runs `bd init`
- Session hooks show task counts and ready IDs
- Skills reference `bd show`, `bd ready`, etc.

Beads is optional - the plugin works without it but task tracking features are disabled.

## Hooks

Automatic context management:

| Hook | Trigger | Action |
|------|---------|--------|
| SessionStart | Chat begins | Load continuation, show status |
| SessionEnd | Chat closes | Remind about uncommitted work |
| PreCompact | Before compaction | Archive session state |
| PostToolUse[Bash] | Large output (>50 lines) | Truncate and archive |
| PostToolUse[MCP] | Large response (>50 lines) | Truncate and archive |

## Multi-Agent Patterns

When spawning sub-agents via Task tool, pass minimal context:

```markdown
Implement task bd-a1b2.
Run `bd show bd-a1b2` for details.
Key files: src/auth/login.ts
```

See `references/multi-agent.md` for patterns.

## Version History

### 0.2.0

- Context optimization (~70% reduction)
- Split skills by session type (progressive loading)
- Lean continuation file format
- Archive scripts truncate large outputs
- Added `/session:status` for context awareness
- Added multi-agent handoff patterns
- Beads-aware hooks (skip menu when beads active)

### 0.1.0

- Initial release
- Basic session workflow

## License

MIT
