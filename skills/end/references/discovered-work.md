# Discovered Work

When user reports new tasks or issues found during the session:

## Gather Info

For each new item, ask:
- Title (brief)
- Priority: 0-4 (0=critical, 2=medium, 4=backlog)
- Blocks anything? Which task ID?

## Create Tasks

```bash
bd create --title="{title}" --priority={priority}
```

If it blocks another task:
```bash
bd dep add {blocked-task-id} {new-task-id}
```

## Multiple Tasks

If several tasks discovered, create them efficiently:
```bash
bd create --title="Task 1" --priority=2
bd create --title="Task 2" --priority=3
bd create --title="Task 3" --priority=2
```

Then add dependencies as needed.

## Note in Session File

Add created tasks to session summary under "Created:" section.
