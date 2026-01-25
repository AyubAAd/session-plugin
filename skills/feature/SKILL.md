---
description: Manage feature specifications and implementation plans
---

# session:feature

Manage feature spec/plan lifecycle. Create new features during plan sessions, track progress during build sessions, and mark complete when finished.

## Usage

```
/session:feature create <name>    - Create a new feature with spec and plan
/session:feature list             - List all features and their status
/session:feature show <name>      - Show feature details
/session:feature complete <name>  - Mark feature as complete
/session:feature archive <name>   - Archive a completed feature's plan
```

## Instructions

### /session:feature create <name>

Creates a new feature directory with spec.md and plan.md from templates.

**Best used during**: PLAN sessions

#### Steps:

1. **Validate feature name**:
   - Must be lowercase, hyphenated (e.g., `user-auth`, `payment-flow`)
   - Cannot already exist

   ```bash
   ls -d .project/features/{{name}} 2>/dev/null && echo "EXISTS"
   ```

2. **Create feature directory**:
   ```bash
   mkdir -p .project/features/{{name}}
   ```

3. **Gather feature information** - Ask the user:
   - "What is this feature about?" (for Overview)
   - "What are the main goals?" (for Goals section)
   - "What should this feature NOT do?" (for Non-Goals)
   - "What are the key requirements?" (for Requirements)
   - "How will we know it's done?" (for Acceptance Criteria)

4. **Create spec.md**:
   Use the template from `plugins/session-workflow/templates/feature-spec.md.template`

   Fill in:
   - `{{FEATURE_NAME}}`: The feature name (title-cased)
   - `{{STATUS}}`: `draft`
   - `{{CREATED_DATE}}`: Today's date
   - `{{UPDATED_DATE}}`: Today's date
   - `{{FEATURE_OVERVIEW}}`: User's description
   - Goals, Non-Goals, Requirements, Acceptance Criteria from user input
   - Leave technical details as placeholders or ask if user wants to fill them

5. **Create plan.md**:
   Use the template from `plugins/session-workflow/templates/feature-plan.md.template`

   Ask the user:
   - "What's the implementation goal?"
   - "What's the current state before this feature?"
   - "What high-level changes are needed?"
   - "How should we break this into phases?"

   Fill in the template with gathered information.

6. **Create beads tasks** (if available):
   Ask: "Should I create beads tasks for this feature?"

   If yes, create tasks based on the implementation phases:
   ```bash
   bd create
   ```

   Link tasks in the plan.md "Related Tasks" section.

7. **Update project state**:
   If this is the active focus, update `.project/state.md`:
   ```markdown
   ## Active Focus
   Feature: {{name}}
   Status: Planning
   ```

8. **Report success**:
   ```
   Feature '{{name}}' created!

   Files:
   - .project/features/{{name}}/spec.md
   - .project/features/{{name}}/plan.md

   Next steps:
   1. Review and refine spec.md
   2. Detail the implementation plan
   3. Start a build session: /session:start build
   ```

---

### /session:feature list

Lists all features and their current status.

#### Steps:

1. **Find all features**:
   ```bash
   ls -d .project/features/*/ 2>/dev/null
   ```

2. **For each feature, extract status**:
   Read the Status line from each spec.md:
   ```bash
   grep "^\*\*State\*\*:" .project/features/*/spec.md 2>/dev/null
   ```

3. **Check for active plans**:
   ```bash
   ls .project/features/*/plan.md 2>/dev/null
   ```

4. **Display summary**:
   ```
   Features:

   | Name | Status | Has Plan | Tasks |
   |------|--------|----------|-------|
   | user-auth | in-progress | yes | 3 open |
   | payment | draft | yes | 0 |
   | notifications | complete | no | - |
   ```

---

### /session:feature show <name>

Shows detailed information about a specific feature.

#### Steps:

1. **Verify feature exists**:
   ```bash
   ls -d .project/features/{{name}} 2>/dev/null
   ```

2. **Read and display spec.md**:
   Show the full specification with current status.

3. **Read and display plan.md** (if exists):
   Show current implementation progress.

4. **Show related beads tasks**:
   ```bash
   bd list --label={{name}} 2>/dev/null
   ```

5. **Provide context**:
   ```
   Feature: {{name}}
   Status: {{status}}

   [Spec summary]

   Plan progress:
   - Phase 1: [status]
   - Phase 2: [status]

   Related tasks: [count] open, [count] closed
   ```

---

### /session:feature complete <name>

Marks a feature as complete, updates spec.md, and optionally removes plan.md.

**Best used during**: BUILD or REVIEW sessions when feature is finished

#### Steps:

1. **Verify feature exists and has plan**:
   ```bash
   ls .project/features/{{name}}/spec.md .project/features/{{name}}/plan.md 2>/dev/null
   ```

2. **Review acceptance criteria**:
   Read the acceptance criteria from spec.md and plan.md.

   Ask the user to confirm each criterion is met:
   ```
   Acceptance Criteria Check:
   - [ ] Criterion 1 - Met? (y/n)
   - [ ] Criterion 2 - Met? (y/n)
   ...
   ```

3. **Gather completion information**:
   - "Summarize what was implemented"
   - "Any lessons learned?"
   - "Any follow-up work needed?"

4. **Update spec.md**:
   - Change `{{STATUS}}` to `complete`
   - Update `{{UPDATED_DATE}}` to today
   - Fill in Completion Notes section:
     - `{{COMPLETION_DATE}}`: Today's date
     - `{{COMPLETION_SUMMARY}}`: User's summary
     - `{{LESSONS_LEARNED}}`: User's lessons learned
   - Mark all acceptance criteria as checked
   - Update technical details with actual implementation (from plan.md)

5. **Archive or delete plan.md**:
   Ask: "Archive the plan to .context/ or delete it?"

   If archive:
   ```bash
   mv .project/features/{{name}}/plan.md .context/archived-plans/{{name}}-plan-{{date}}.md
   ```

   If delete:
   ```bash
   rm .project/features/{{name}}/plan.md
   ```

6. **Close related beads tasks**:
   ```bash
   bd list --label={{name}} --status=open
   ```

   Ask if any open tasks should be closed or moved.

7. **Update project state**:
   Update `.project/state.md` to reflect completion.

8. **Report success**:
   ```
   Feature '{{name}}' marked complete!

   Updated: .project/features/{{name}}/spec.md
   Plan: [archived to / deleted]

   Completion summary: {{summary}}
   ```

---

### /session:feature archive <name>

Archives a completed feature's plan without marking complete (useful for pausing work).

#### Steps:

1. **Verify plan exists**:
   ```bash
   ls .project/features/{{name}}/plan.md 2>/dev/null
   ```

2. **Create archive directory** (if needed):
   ```bash
   mkdir -p .context/archived-plans
   ```

3. **Archive the plan**:
   ```bash
   mv .project/features/{{name}}/plan.md .context/archived-plans/{{name}}-plan-{{date}}.md
   ```

4. **Update spec.md status** to `paused` if appropriate.

5. **Report**:
   ```
   Plan archived: .context/archived-plans/{{name}}-plan-{{date}}.md

   To resume work later:
   1. Copy the plan back to .project/features/{{name}}/plan.md
   2. Start a build session: /session:start build
   ```

---

## Integration with Session Types

### During PLAN sessions

When `/session:start plan` detects the user wants to create a new feature:
- Suggest: "Would you like to create a feature? Run `/session:feature create <name>`"
- The feature command handles spec and plan creation

### During BUILD sessions

When `/session:start build` loads a feature:
- Automatically loads spec.md and plan.md
- Shows current implementation phase
- Links to related beads tasks

### During session end

When `/session:end` runs with a feature in progress:
- Ask if the feature is complete
- If yes, prompt to run `/session:feature complete <name>`
- If no, update plan.md with progress

---

## Examples

### Creating a new feature

```
User: /session:feature create user-notifications

Assistant: Let me help you create the user-notifications feature.

What is this feature about?

User: Send push notifications and in-app alerts when users receive messages or updates.

Assistant: Great\! What are the main goals for this feature?

User: Real-time notifications, customizable preferences, support both push and in-app

Assistant: Creating feature...

Created: .project/features/user-notifications/spec.md
Created: .project/features/user-notifications/plan.md

Feature 'user-notifications' created\!

Files:
- .project/features/user-notifications/spec.md
- .project/features/user-notifications/plan.md

Next steps:
1. Review and refine spec.md
2. Detail the implementation plan
3. Start a build session: /session:start build
```

### Completing a feature

```
User: /session:feature complete user-notifications

Assistant: Let me verify the feature is ready for completion...

Reading: .project/features/user-notifications/spec.md
Reading: .project/features/user-notifications/plan.md

Acceptance Criteria Check:
- [x] Push notifications work on iOS and Android - Met? (y/n)

User: y

Assistant:
- [x] In-app notification center shows history - Met? (y/n)

User: y

Assistant:
- [x] Users can configure notification preferences - Met? (y/n)

User: y

Assistant: All criteria met\!

Summarize what was implemented:

User: Added Firebase push notifications, in-app notification center with 30-day history, and a preferences page.

Assistant: Archive the plan to .context/ or delete it?

User: archive

Assistant:
Feature 'user-notifications' marked complete\!

Updated: .project/features/user-notifications/spec.md
Plan: archived to .context/archived-plans/user-notifications-plan-2024-01-22.md

Completion summary: Added Firebase push notifications, in-app notification center with 30-day history, and a preferences page.
```

### Listing features

```
User: /session:feature list

Assistant:
Features:

| Name | Status | Has Plan | Tasks |
|------|--------|----------|---------|
| user-auth | complete | no | - |
| user-notifications | complete | no | - |
| payment-flow | in-progress | yes | 5 open |
| analytics | draft | yes | 2 open |
```
