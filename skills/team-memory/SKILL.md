# Team Memory

View or update shared memory for a team.

## Invocation

```
/team-memory
```

## Usage

```
/team-memory <team-id> [action] [options]
```

## View Memory

```
/team-memory team-123
```

Shows the full shared memory including:
- Team context (goal, constraints, key files)
- Decisions made
- Progress (tasks, blockers, milestones)
- Handoffs between workers
- Findings by category

## Actions

### Add Decision

```
/team-memory team-123 --add-decision "<decision>" --rationale "<why>" [--by "<who>"]
```

### Add Blocker

```
/team-memory team-123 --add-blocker "<description>" --severity <level>
```

Severity levels: `low`, `medium`, `high`, `critical`

### Resolve Blocker

```
/team-memory team-123 --resolve-blocker "<blocker-id>" --resolution "<how it was resolved>"
```

### Add Finding

```
/team-memory team-123 \
  --add-finding "<description>" \
  --category <type> \
  [--files "file1,file2"]
```

Categories: `bug`, `security`, `performance`, `architecture`, `other`

### Add Key File

```
/team-memory team-123 --add-key-file "src/auth/oauth.ts"
```

### Add Architecture Note

```
/team-memory team-123 --add-arch-note "Auth module uses adapter pattern for providers"
```

### Add Milestone

```
/team-memory team-123 --add-milestone "OAuth2 flow implemented"
```

## Output Format

```markdown
# Team Memory: Auth Feature

## Context
**Goal:** Implement OAuth2 authentication
**Working Directory:** /project/src

### Constraints
- No breaking changes to existing API
- 80% test coverage required

### Key Files
- src/auth/oauth.ts
- src/auth/providers/google.ts

### Architecture Notes
- Auth module uses adapter pattern for providers

## Decisions (2)

### 1. Use JWT for session management
- **Rationale:** Stateless, scalable, industry standard
- **Made by:** planner

## Progress

### Tasks (5)
- [completed] Design OAuth flow
- [in-progress] Implement Google provider
- [pending] Add refresh token rotation

### Blockers (1 active)
- [HIGH] Missing API credentials

## Findings

### Security (2)
- SQL injection in user search
- Weak token entropy

## Handoffs (1)
- **planner → security-reviewer:** Plan complete, review OAuth flow
```

## Memory Structure

The shared memory structure (`TeamMemory`) contains:

```typescript
{
  context: {
    goal: string;
    constraints: string[];
    workingDirectory: string;
    keyFiles: string[];
    architectureNotes: string[];
  };
  decisions: Decision[];
  progress: {
    tasks: Task[];
    blockers: Blocker[];
    milestones: string[];
  };
  handoffs: Handoff[];
  findings: Finding[];
}
```

## Implementation Details

Uses `ContextRouter` from `~/.claude/lib/team/context.ts`.

Memory is persisted to `~/.claude/teams/{team-id}/memory/shared.json`.
