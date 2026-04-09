# Team Delegate

Delegate a task to a specific worker in a team.

## Invocation

```
/team-delegate
```

## Usage

```
/team-delegate --team <team-id> --worker <worker-role> --task "<description>" [options]
```

### Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--team` | Yes | Team ID (from `/team-create` or `/team-status`) |
| `--worker` | Yes | Worker role (e.g., `planner`, `security-reviewer`) |
| `--task` | Yes | Task description |
| `--context` | No | Additional context for the worker |
| `--priority` | No | Task priority: `low`, `normal`, `high`, `urgent` |
| `--background` | No | Run worker in background (default: false) |

## Examples

### Basic Delegation

```
/team-delegate \
  --team team-1234567890-abc123 \
  --worker planner \
  --task "Create implementation plan for OAuth2 authentication"
```

### With Context

```
/team-delegate \
  --team team-123 \
  --worker security-reviewer \
  --task "Review the proposed authentication flow for vulnerabilities" \
  --context "Focus on token storage and session management"
```

### Background Execution

```
/team-delegate \
  --team team-123 \
  --worker code-reviewer \
  --task "Review all TypeScript files in src/auth/" \
  --background
```

### Parallel Delegation

```
# These will run in parallel
/team-delegate --team team-123 --worker planner --task "Design API structure"
/team-delegate --team team-123 --worker security-reviewer --task "Audit existing code"
/team-delegate --team team-123 --worker tdd-guide --task "Plan test strategy"
```

## What Happens

1. Task is assigned to the specified worker
2. Worker receives:
   - Task description
   - Permission context (allowed tools, restrictions)
   - Shared team memory (goal, decisions, findings)
   - Any handoffs from other workers
3. Worker executes using the Task tool
4. Results are captured in shared memory

## Worker Prompt Structure

The worker receives a prompt containing:

- Task description
- Permission level and allowed tools
- Team context from shared memory
- Any handoffs from other workers
- Instructions for completing the task

## Checking Results

After delegation:

```
# Check worker progress
/team-status team-123

# View shared memory for results
/team-memory team-123
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Team not found | Invalid team ID | Check `/team-status` for valid IDs |
| Worker not found | Invalid worker role | Check team manifest for available workers |
| Permission denied | Task requires higher tier | Request escalation or use different worker |
| Worker busy | Worker already running | Wait for completion or cancel |

## Implementation Details

Uses `TeamManager.delegateTask()` from `~/.claude/lib/team/manager.ts`.

The delegation creates a Task tool call with the worker's prompt, which includes permission context from `PermissionBroker` and shared memory from `ContextRouter`.
