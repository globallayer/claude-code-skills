# Team Status

Display the current status of a team, including worker progress, blockers, and recent decisions.

## Invocation

```
/team-status
```

## Usage

```
/team-status [team-id]
```

### Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `team-id` | No | Specific team to show. If omitted, shows all teams. |

## Output Format

### Single Team View

```
# Team: Auth Feature

**ID:** team-1234567890-abc123
**Phase:** executing
**Progress:** 67%

## Workers
- Total: 3
- Pending: 0
- Running: 1
- Completed: 2
- Failed: 0

## Active Blockers
- [HIGH] Waiting for API credentials

## Recent Decisions
- Use JWT for session management
- Store tokens in httpOnly cookies
- Implement refresh token rotation
```

### All Teams View

```
# Active Teams

| Name | ID | Phase | Progress | Workers |
|------|----|-------|----------|---------|
| Auth Feature | team-123... | executing | 67% | 3 |
| Refactor DB | team-456... | planning | 20% | 2 |

Use `/team-status <team-id>` for details.
```

## Team Phases

| Phase | Description |
|-------|-------------|
| `initializing` | Team being set up |
| `planning` | Decomposing goal into tasks |
| `executing` | Workers actively working |
| `reviewing` | Reviewing worker outputs |
| `completed` | Goal achieved |
| `failed` | Unrecoverable failure |
| `cancelled` | Manually stopped |

## Worker Status

| Status | Description |
|--------|-------------|
| `pending` | Not yet started |
| `running` | Currently executing |
| `completed` | Finished successfully |
| `failed` | Encountered error |
| `cancelled` | Manually stopped |

## Examples

```
# Show all teams
/team-status

# Show specific team
/team-status team-1234567890-abc123

# Common workflow
/team-create --name "Feature" --goal "Build X" --workers "planner,coder"
/team-status  # See the new team
/team-delegate --team team-xxx --worker planner --task "Plan the feature"
/team-status team-xxx  # Check progress
```

## Implementation Details

Uses `TeamManager.getTeamStatus()` and `TeamManager.listTeams()` from `~/.claude/lib/team/manager.ts`.
