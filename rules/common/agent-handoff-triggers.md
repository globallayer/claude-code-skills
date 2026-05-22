# Agent Handoff Triggers

> Automated triggers that invoke the next agent in a workflow chain.

## Trigger Rules

### After Code Changes (Edit/Write)

| Condition | Trigger Agent | Reason |
|-----------|---------------|--------|
| TypeScript file modified | code-reviewer | Quality check |
| Security-sensitive file | security-reviewer | Security audit |
| Test file modified | tdd-guide | Verify test validity |
| Config file modified | architect | Architecture review |

### Security-Sensitive Files

Files that auto-trigger security-reviewer:
- `**/auth/**` - Authentication code
- `**/middleware/auth*` - Auth middleware
- `**/*password*` - Password handling
- `**/*token*` - Token handling
- `**/*secret*` - Secret management
- `**/*crypto*` - Cryptography
- `**/*payment*` - Payment processing
- `**/api/admin/**` - Admin endpoints

### After Build/Test Completion

| Event | Trigger Agent | Condition |
|-------|---------------|-----------|
| Tests pass | code-reviewer | When tdd-guide completes |
| Tests fail | build-error-resolver | Automatic fix attempt |
| Build fails | build-error-resolver | Automatic fix attempt |
| Security scan fails | security-reviewer | Review findings |

### After PR Creation

| Event | Trigger Agent |
|-------|---------------|
| PR created | code-reviewer |
| PR updated | code-reviewer (incremental) |
| PR approved | doc-updater (if needed) |

## Implementation

These triggers are implemented via:

1. **PostToolUse hooks** - Already active in hooks.json:
   - `quality-gate.js` - Runs after Edit/Write
   - `post-edit-typecheck.js` - TypeScript checks
   - `post-edit-console-warn.js` - Code quality warnings

2. **Pattern detection** - In continuous-learning hooks:
   - `observe.sh` - Captures tool use patterns
   - `evaluate-session.js` - Extracts patterns

3. **Agent orchestration** - Via /orchestrate skill:
   - Explicit workflow chains
   - Parallel execution where possible

## Manual Override

To skip automatic triggers:
```bash
export SKIP_AGENT_HANDOFF=1
```

## Escalation

If auto-triggered agent fails 3 times:
1. Log to ~/.claude/memory/errors.json
2. Alert user
3. Continue without blocking

## Integration with Token-Max

Handoff triggers respect token-max policy:
- Independent reviews run in parallel
- Sequential dependencies wait for completion
- Model routing follows standard rules
