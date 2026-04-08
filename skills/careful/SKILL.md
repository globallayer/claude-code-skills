---
name: careful
description: "SAFETY MODE: Invoke with /careful when working with production systems, sensitive data, or when you want extra protection against destructive commands. Blocks rm -rf, DROP TABLE, git push --force, kubectl delete, and other dangerous operations. Use when debugging prod or working with critical systems."
risk: low
source: local
---

# Careful Mode - Destructive Command Protection

Activates safety guards that block potentially destructive commands. Use when working with production systems or sensitive data.

## When to Use

Invoke `/careful` when:
- Debugging production systems
- Working with production databases
- Deploying to live environments
- Making changes to critical infrastructure
- Working with irreplaceable data
- Nervous about accidental deletions

## How It Works

When activated, this skill instructs Claude to:
1. **STOP** before executing any command matching the blocked patterns
2. **EXPLAIN** what the command would do
3. **ASK** for explicit confirmation before proceeding
4. **SUGGEST** safer alternatives when available

## Blocked Command Patterns

### File System Destruction

| Pattern | Risk | Alternative |
|---------|------|-------------|
| `rm -rf` | Recursive delete, no confirmation | `rm -ri` (interactive) |
| `rm -r /` | Delete entire filesystem | NEVER do this |
| `rm -rf *` | Delete all in directory | `ls` first, then specific files |
| `rm -rf .` | Delete current directory | Be specific about what to delete |
| `> file` | Truncate file to zero | Backup first: `cp file file.bak` |

### Git Destruction

| Pattern | Risk | Alternative |
|---------|------|-------------|
| `git push --force` | Overwrites remote history | `git push --force-with-lease` |
| `git push -f` | Same as above | `git push --force-with-lease` |
| `git reset --hard` | Discards all local changes | `git stash` first |
| `git clean -fd` | Deletes untracked files | `git clean -fdn` (dry run) |
| `git checkout .` | Discards all changes | `git stash` first |
| `git branch -D` | Force delete branch | `git branch -d` (safe delete) |

### Database Destruction

| Pattern | Risk | Alternative |
|---------|------|-------------|
| `DROP TABLE` | Deletes table permanently | Backup first, use transactions |
| `DROP DATABASE` | Deletes entire database | NEVER in production |
| `TRUNCATE` | Deletes all rows instantly | Use DELETE with WHERE |
| `DELETE FROM x` (no WHERE) | Deletes all rows | Add WHERE clause |
| `UPDATE x SET` (no WHERE) | Updates all rows | Add WHERE clause |

### Kubernetes/Docker Destruction

| Pattern | Risk | Alternative |
|---------|------|-------------|
| `kubectl delete` | Removes resources | `kubectl delete --dry-run` first |
| `kubectl delete ns` | Deletes namespace + all resources | NEVER in production |
| `docker system prune -a` | Removes all unused data | `docker system prune` (less aggressive) |
| `docker rm -f $(docker ps -aq)` | Force removes all containers | Stop gracefully first |

### Cloud/Infrastructure

| Pattern | Risk | Alternative |
|---------|------|-------------|
| `terraform destroy` | Destroys infrastructure | `terraform plan -destroy` first |
| `aws s3 rm --recursive` | Deletes S3 bucket contents | Enable versioning first |
| `heroku apps:destroy` | Destroys entire app | Export data first |

## Activation Behavior

When `/careful` is active:

```
User: "Clean up the temp files"

Claude (without /careful):
> rm -rf /tmp/myapp/*
Done.

Claude (with /careful):
BLOCKED: rm -rf detected

This command would recursively delete all files in /tmp/myapp/
without confirmation.

Safer alternatives:
1. List first: ls -la /tmp/myapp/
2. Interactive: rm -ri /tmp/myapp/*
3. Specific files: rm /tmp/myapp/*.tmp

Do you want me to proceed with one of these alternatives,
or confirm the original command?
```

## Safe Mode Rules

When this skill is active, Claude MUST:

1. **Never execute blocked patterns without explicit user confirmation**
2. **Always show what the command would do before running**
3. **Suggest safer alternatives when available**
4. **Double-check database operations against production**
5. **Verify git operations won't destroy history**

## Session Persistence

This skill remains active for the entire session after invocation.
To deactivate, start a new session or explicitly say "disable careful mode".

## Combining with Other Skills

Works well with:
- `/deploy-railway` - Extra safety during deployments
- `/database-migrations` - Protect against migration mistakes
- `/commit` - Prevent force-push accidents

## Emergency Override

If you absolutely must run a blocked command:

1. Explicitly state: "I understand the risk, proceed with [exact command]"
2. Claude will ask for confirmation one more time
3. Only then will the command execute

## What This Skill Does NOT Block

- Normal file operations (single file rm, mv, cp)
- Safe git operations (commit, push, pull, fetch)
- Read-only database queries (SELECT)
- Container operations that don't destroy data

## Configuration

To customize blocked patterns, create `config.json` in this skill directory:

```json
{
  "additional_blocks": [
    "my-dangerous-script.sh",
    "npm run nuke"
  ],
  "allow_patterns": [
    "rm -rf node_modules",
    "rm -rf dist"
  ],
  "confirmation_required": true,
  "log_blocked_commands": true
}
```

## Why Use This?

- **Prevents accidents**: One typo in `rm -rf` can destroy hours of work
- **Forces deliberation**: Makes you think before destructive actions
- **Audit trail**: Know what dangerous commands were considered
- **Peace of mind**: Work confidently near production systems
