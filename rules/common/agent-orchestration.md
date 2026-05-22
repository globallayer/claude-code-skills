# Agent Orchestration Protocol

> **Principle #6:** Three Archetypes — Builder-Operator, DRI, Strategist

## Agent Archetypes

### Builder-Operator (Executes)
Writes code, ships features, fixes bugs.

| Agent | Specialty |
|-------|-----------|
| `build-error-resolver` | Fix build/compilation errors |
| `tdd-guide` | Test-driven development |
| `e2e-runner` | End-to-end testing |
| `refactor-cleaner` | Dead code cleanup |
| `doc-updater` | Documentation updates |

### DRI (Owns Outcome)
Owns strategy and outcomes end-to-end.

| Agent | Specialty |
|-------|-----------|
| `planner` | Implementation planning |
| `architect` | System design |
| `project-completion-manager` | Project tracking |

### Strategist (Advises)
Advises, audits, doesn't execute.

| Agent | Specialty |
|-------|-----------|
| `code-reviewer` | Code quality |
| `security-reviewer` | Security vulnerabilities |
| `performance-optimizer` | Performance analysis |
| `typescript-reviewer` | TypeScript best practices |
| `python-reviewer` | Python best practices |
| `go-reviewer` | Go best practices |
| `rust-reviewer` | Rust best practices |

## Handoff Protocol

### Standard Feature Flow

```
1. [DRI] planner → Creates implementation plan
2. [Builder] tdd-guide → Writes tests first (RED)
3. [Builder] tdd-guide → Implements until tests pass (GREEN)
4. [Builder] refactor-cleaner → Refactors (REFACTOR)
5. [Strategist] code-reviewer → Reviews code quality
6. [Strategist] security-reviewer → Reviews security
7. [DRI] planner → Verifies completion against spec
8. [User] → Final approval
```

### Bug Fix Flow

```
1. [DRI] planner → Analyzes bug, creates fix plan
2. [Builder] tdd-guide → Writes regression test (RED)
3. [Builder] build-error-resolver → Fixes bug (GREEN)
4. [Strategist] code-reviewer → Reviews fix
5. [DRI] planner → Verifies bug is fixed
```

### Security Issue Flow

```
1. [Strategist] security-reviewer → Identifies vulnerability
2. [DRI] planner → Creates remediation plan
3. [Builder] build-error-resolver → Implements fix
4. [Strategist] security-reviewer → Verifies fix
5. [Strategist] security-reviewer → Full security audit
```

## DRI Assignment

Each domain has a designated DRI agent:

| Domain | DRI Agent | Backup |
|--------|-----------|--------|
| Code quality | code-reviewer | typescript-reviewer |
| Security | security-reviewer | - |
| Architecture | architect | planner |
| Testing | tdd-guide | e2e-runner |
| Performance | performance-optimizer | - |
| Documentation | doc-updater | - |

## Agent Memory

Agents maintain context about their domain:

```
~/.claude/agents/memory/
├── code-reviewer/
│   ├── patterns.json      # Code patterns seen
│   ├── issues.json        # Common issues found
│   └── projects.json      # Project-specific context
├── security-reviewer/
│   ├── vulnerabilities.json
│   └── remediations.json
└── ...
```

## Parallel Agent Execution

### When to Run in Parallel

```
# Independent reviews (PARALLEL)
- code-reviewer → Module A
- security-reviewer → Module A
- typescript-reviewer → Module A

# Sequential dependency (SEQUENTIAL)
- tdd-guide → Write tests
- tdd-guide → Implement
- code-reviewer → Review
```

### Parallel Agent Template

```markdown
Launching parallel agents for [task]:

Agent 1: [type] → [scope]
Agent 2: [type] → [scope]
Agent 3: [type] → [scope]

[Single message with 3 Task tool invocations]
```

## Agent Communication

Agents communicate through:

1. **Task results** - Output from completed agent work
2. **Shared memory** - `~/.claude/memory/` files
3. **Project files** - CLAUDE.md, TODO.md, specs/
4. **Queue** - `~/.claude/QUEUE.md`

## Escalation Protocol

| Situation | Escalation |
|-----------|------------|
| Build fails repeatedly | build-error-resolver → architect |
| Security vulnerability found | security-reviewer → (immediate user notification) |
| Architecture decision needed | planner → architect |
| Performance issue detected | code-reviewer → performance-optimizer |

## Integration with Workflows

### `/orchestrate feature`

```
1. planner creates spec
2. User approves spec
3. tdd-guide implements (TDD)
4. code-reviewer + security-reviewer review (parallel)
5. e2e-runner tests
6. planner marks complete
```

### `/orchestrate bugfix`

```
1. planner analyzes
2. tdd-guide writes regression test
3. build-error-resolver fixes
4. code-reviewer reviews
5. planner verifies
```

### `/orchestrate security`

```
1. security-reviewer full audit
2. planner prioritizes findings
3. build-error-resolver fixes each
4. security-reviewer verifies each
5. security-reviewer final audit
```
