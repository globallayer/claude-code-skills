# Team Stop

Stop a running team and optionally delete it.

## Invocation

```
/team-stop
```

## Usage

```
/team-stop <team-id> [options]
```

### Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `team-id` | Yes | Team ID to stop |
| `--delete` | No | Delete team after stopping (removes all state) |
| `--force` | No | Force stop even if workers are in critical operations |

## Examples

### Stop Team (Preserve State)

```
/team-stop team-1234567890-abc123
```

The team can be resumed later:
```
/team-status team-1234567890-abc123  # Still shows team
```

### Stop and Delete

```
/team-stop team-1234567890-abc123 --delete
```

Team is completely removed.

### Force Stop

```
/team-stop team-123 --force
```

Use when normal stop doesn't work (e.g., hung workers).

## What Happens

1. All running workers are cancelled
2. Team phase is set to `cancelled`
3. State is saved to disk (unless `--delete`)
4. With `--delete`, team directory is removed

## Worker Cleanup

When a team is stopped:

| Mode | Cleanup Action |
|------|----------------|
| `in-process` | Task cancelled |
| `tmux` | Session killed |
| `worktree` | Branch abandoned (not deleted) |

## Preserved Data

Without `--delete`, the following is preserved:
- Team manifest (`manifest.json`)
- Execution state (`state.json`)
- Shared memory (`memory/shared.json`)
- Event log (`memory/events.json`)
- Worker state files

This allows:
- Reviewing what happened
- Resuming partially completed work
- Auditing decisions and findings

## Cleanup Workflow

```
# Stop team but keep data for review
/team-stop team-123

# Review final state
/team-status team-123
/team-memory team-123

# Delete when done reviewing
/team-stop team-123 --delete
```

## Implementation Details

Uses `TeamManager.stopTeam()` and `TeamManager.deleteTeam()` from `~/.claude/lib/team/manager.ts`.
