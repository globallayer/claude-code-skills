# Unified Task Queue

**Last Updated:** 2026-05-22
**Mode:** Assisted (propose → approve)

---

## Active Priority Queue

| # | Project | Task | Status | DRI Agent | Blocked By |
|---|---------|------|--------|-----------|------------|
| 1 | Merka2a | Phase 2: Partner outreach | IN_PROGRESS | planner | - |
| 2 | Merka2a | Frontend test setup | READY | tdd-guide | - |
| 3 | Astrobiography | App Store screenshots | READY | e2e-runner | - |
| 4 | Astrobiography | Google Play submission | BLOCKED | - | Screenshots |
| 5 | ChartCrack | DB migration 0011 | BLOCKED | build-error-resolver | iOS config |
| 6 | EverGreen | Google Business Profile | READY | - | - |
| 7 | RevisionApp | Security fixes (API key) | CRITICAL | security-reviewer | - |

---

## Cross-Project Notes

### Pattern Sharing
- JWT + refresh token pattern from Merka2a → Port to Astrobiography
- Build error memory pattern → Implement in ChartCrack
- Spec-first workflow → Enforce in all projects

### Blockers Requiring User Input
- [ ] Merka2a: User to test onboarding flow
- [ ] Astrobiography: User to provide App Store credentials
- [ ] ChartCrack: User to confirm DB migration

---

## Auto-Context Switch Rules

When blocked on a task:
1. Log blocker to this queue
2. Move to next READY task
3. Notify user when unblocked

Priority order:
1. CRITICAL security issues
2. IN_PROGRESS tasks
3. READY tasks (by project priority)
4. BLOCKED tasks (monitor only)

---

## Project Priority Order

1. **Merka2a** - Reference implementation, revenue-critical
2. **Astrobiography** - Near launch, user-facing
3. **ChartCrack** - Technical debt blocking progress
4. **EverGreen** - Production, low maintenance
5. **RevisionApp** - Security critical but paused

---

## Weekly Review Checklist

- [ ] All CRITICAL tasks addressed
- [ ] No task blocked > 48 hours without escalation
- [ ] Cross-project patterns logged to ~/.claude/memory/patterns.json
- [ ] Decisions logged to ~/.claude/memory/decisions.json
- [ ] Mode graduation metrics updated

---

## Queue Operations

### Add Task
```
Task: [description]
Project: [project-name]
Status: READY | IN_PROGRESS | BLOCKED | CRITICAL
DRI: [agent-name]
Blocked By: [dependency or -]
```

### Update Status
```
Task #[n] → [NEW_STATUS]
Reason: [why]
Next: [what happens next]
```

### Remove Task
```
Task #[n] → COMPLETED
Verified: [yes/no]
Logged: [decision/pattern logged? y/n]
```
