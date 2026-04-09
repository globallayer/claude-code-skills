# Team Create

Create a coordinated team of agents to work on a goal in parallel.

## Invocation

```
/team-create
```

## Usage

The `/team-create` command creates a new multi-agent team for parallel task execution.

### Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--name` | Yes | Team name (short identifier) |
| `--goal` | Yes | Team objective/goal |
| `--workers` | Yes | Comma-separated worker specs (format: `role:model`) |
| `--mode` | No | Execution mode: `in-process`, `tmux`, `worktree`, `auto` (default: auto) |
| `--permission` | No | Permission tier: `ReadOnly`, `SafeWrite`, `Write`, `Execute`, `DangerFullAccess` (default: Execute) |
| `--timeout` | No | Timeout in milliseconds (default: 600000) |
| `--constraints` | No | Comma-separated constraints |

### Worker Spec Format

```
role:model

Examples:
- planner:opus        # Planner using Opus model
- security-reviewer   # Security reviewer using default model
- code-reviewer:haiku # Code reviewer using Haiku model
```

### Available Worker Roles

Standard roles (map to agents in `~/.claude/agents/`):

| Role | Purpose |
|------|---------|
| `planner` | Implementation planning, task breakdown |
| `architect` | System design, technical decisions |
| `tdd-guide` | Test-driven development |
| `code-reviewer` | Code quality review |
| `security-reviewer` | Security analysis |
| `build-error-resolver` | Fix build errors |
| `refactor-cleaner` | Dead code cleanup |
| `doc-updater` | Documentation updates |

### Permission Tiers

| Tier | Level | Capabilities |
|------|-------|--------------|
| `ReadOnly` | 1 | Read files, Grep, Glob only |
| `SafeWrite` | 2 | + Edit existing files |
| `Write` | 3 | + Create/delete files, safe Bash |
| `Execute` | 4 | + Any Bash, git operations |
| `DangerFullAccess` | 5 | + Force push, destructive git |

## Examples

### Simple Team

```
/team-create --name "Auth" --goal "Implement OAuth2 authentication" --workers "planner,security-reviewer,tdd-guide"
```

### Full Specification

```
/team-create \
  --name "Feature X" \
  --goal "Implement feature X with full test coverage" \
  --workers "planner:opus,architect:opus,tdd-guide:sonnet,code-reviewer:haiku" \
  --mode auto \
  --permission Execute \
  --timeout 900000 \
  --constraints "No breaking changes,80% test coverage required"
```

## What Happens

1. Team directory created at `~/.claude/teams/{team-id}/`
2. Workers registered with permission broker
3. Shared memory initialized with goal and constraints
4. Workers prepared for task delegation
5. Returns team ID for subsequent commands

## Next Steps

After creating a team:

```
# Check team status
/team-status {team-id}

# Delegate tasks to workers
/team-delegate --team {team-id} --worker planner --task "Create implementation plan"

# View shared memory
/team-memory {team-id}

# Stop the team when done
/team-stop {team-id}
```

## Implementation Details

This skill uses the Team/Coordinator system library at `~/.claude/lib/team/`.

Key components:
- **TeamManager**: Handles team lifecycle
- **PermissionBroker**: Manages 5-tier permission model
- **ContextRouter**: Manages shared memory
- **WorkerPool**: Coordinates worker execution

See `~/.claude/lib/team/types.ts` for TypeScript interfaces.
