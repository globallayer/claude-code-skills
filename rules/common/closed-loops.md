# Closed Loop Protocols

> **Principle #2:** A closed loop is self-correcting — it monitors output and tunes itself toward the goal.

## Core Principle

Every critical process must:
1. **Take action**
2. **Measure outcome**
3. **Calculate delta from goal**
4. **Make adjustment OR escalate**
5. **Continue loop**

---

## Build Loop

```
Code changed
    │
    ▼
npm test (or equivalent)
    │
    ├── Pass → Done
    │
    └── Fail → spawn build-error-resolver
                    │
                    ▼
               Fix applied
                    │
                    ▼
               npm test again
                    │
                    ├── Pass → Log fix to errors.json → Done
                    │
                    └── Fail (3x) → Escalate to user
```

### Implementation

```bash
# .claude/hooks/post-edit.sh
#!/bin/bash
# Triggered after file edits

FILE="$1"
EXT="${FILE##*.}"

case "$EXT" in
  ts|tsx|js|jsx)
    npm test -- --related "$FILE" 2>&1 || {
      echo "HOOK: Test failed, spawning build-error-resolver"
      # Agent spawned automatically
    }
    ;;
esac
```

---

## Error Learning Loop

```
Error encountered
    │
    ▼
Search ~/.claude/memory/errors.json
    │
    ├── Found → Apply known fix → Verify → Done
    │
    └── Not found → Debug manually
                        │
                        ▼
                   Fix applied
                        │
                        ▼
                   Verify fix works
                        │
                        ▼
                   Log to errors.json
                        │
                        ▼
                   Done (pattern learned)
```

### Error Pattern Format

```json
{
  "id": "unique-id",
  "date": "2026-05-22",
  "category": "build|runtime|database|auth|api|frontend|devops|git",
  "error": "Error message or regex pattern",
  "solution": "What fixed it",
  "context": "Where this occurred",
  "verified": true,
  "occurrences": 1
}
```

### Categories

| Category | Examples |
|----------|----------|
| `build` | TypeScript errors, webpack failures, missing dependencies |
| `runtime` | Uncaught exceptions, null references, timeout errors |
| `database` | Migration failures, connection errors, query timeouts |
| `auth` | Token expiry, permission denied, invalid credentials |
| `api` | 4xx/5xx responses, CORS issues, rate limiting |
| `frontend` | React errors, hydration mismatches, CSS issues |
| `devops` | Docker failures, CI/CD errors, deployment issues |
| `git` | Merge conflicts, push rejections, hook failures |

---

## PR Loop

```
Code complete
    │
    ▼
code-reviewer (parallel)
security-reviewer (parallel)
    │
    ├── No issues → Create PR
    │
    └── Issues found → Fix issues
                          │
                          ▼
                      Re-review
                          │
                          └── Loop until clean
```

---

## Documentation Loop

```
Code changed
    │
    ▼
Check affected CODEMAPS
    │
    ├── CODEMAPS current → Done
    │
    └── CODEMAPS stale → spawn doc-updater
                              │
                              ▼
                         Update CODEMAPS
                              │
                              ▼
                         Verify references
                              │
                              ▼
                         Done
```

---

## Deploy Loop

```
Code merged to main
    │
    ▼
Deploy to staging
    │
    ▼
Run E2E tests
    │
    ├── Pass → Deploy to production
    │              │
    │              ▼
    │         Monitor for 15 min
    │              │
    │              ├── Stable → Done
    │              │
    │              └── Errors → Rollback + Alert
    │
    └── Fail → Block deploy
                   │
                   ▼
              spawn e2e-runner
                   │
                   ▼
              Fix + Re-test
```

---

## Spec Compliance Loop

```
Implementation complete
    │
    ▼
Compare to spec
    │
    ├── All criteria met → Mark spec complete
    │
    └── Criteria missing → Loop back to implementation
                               │
                               ├── Fixable → Fix
                               │
                               └── Spec unclear → Escalate to user
```

---

## Memory Sync Loop

```
Session ending (shut x)
    │
    ▼
Check for new patterns
    │
    ▼
Check for new decisions
    │
    ▼
Check for new error solutions
    │
    ▼
Sync to ~/.claude/memory/
    │
    ▼
Push to git
    │
    ▼
Done
```

---

## Escalation Triggers

| Situation | After | Escalate To |
|-----------|-------|-------------|
| Build fails | 3 attempts | User |
| Test fails | 3 attempts | User |
| Security issue found | Immediately | User |
| Spec ambiguous | 1 attempt | User |
| Performance degradation | 2 attempts | performance-optimizer |
| Memory sync fails | 2 attempts | User |

---

## Monitoring Metrics

Track these for each loop:

| Metric | Target | Alert If |
|--------|--------|----------|
| Build loop success rate | > 95% | < 90% |
| Error pattern hit rate | > 60% | < 40% |
| Spec compliance rate | 100% | < 100% |
| PR review iterations | < 2 | > 3 |
| Deploy rollback rate | < 5% | > 10% |

---

## Integration with Memory Layer

All loops feed into the memory layer:

```
~/.claude/memory/
├── patterns.json    ← Successful patterns from any loop
├── decisions.json   ← Architecture decisions during loops
├── errors.json      ← Error patterns and solutions
└── context.json     ← Loop performance metrics
```
