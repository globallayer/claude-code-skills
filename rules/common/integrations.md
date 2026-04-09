# External Integrations

## Conflict-Aware Integration Rules

### Tool Priority

| Task | Use This | NOT This |
|------|----------|----------|
| Code pattern extraction | `/skill-create` | - |
| Session workflow capture | `/skillify` | - |
| Skill installation | Antigravity (existing) | skillpm (unless missing) |
| Multi-agent orchestration | `/orchestrate`, `/team-create` | KAIROS |
| Daemon/autonomous mode | `/loop-start` | KAIROS daemon |

---

## claude-skillify (Plugin)

**Status:** SAFE TO INSTALL

After completing repeatable workflows, run `/skillify`:
- Deployments (Railway, Vercel, Netlify)
- PR creation and review cycles
- Database migrations
- API integrations
- Build/CI fixes

**Complements** `/skill-create` (git-based) with session-based capture.

---

## skillpm (npm)

**Status:** INSTALL WITH CAUTION

Before installing any skill:
```bash
# Check if skill exists in Antigravity collection
ls ~/.claude/skills/ | grep -i "<skill-name>"
```

Only use skillpm for:
- Skills with npm dependencies
- Skills NOT in Antigravity collection
- Publishing your own skills to npm

---

## KAIROS Framework

**Status:** DO NOT INSTALL - Use existing system

Your system already has superior orchestration:

| KAIROS Feature | Existing Equivalent |
|----------------|---------------------|
| 7 SDLC agents | 32 specialized agents |
| Filesystem mailbox | `~/.claude/teams/` |
| Daemon mode | `/loop-start`, `/loop-status` |
| Feature workflow | `/orchestrate feature` |
| Bugfix workflow | `/orchestrate bugfix` |

---

## Integration Checklist

Before ending a session with repeatable work:
- [ ] Consider `/skill-create` for code patterns
- [ ] Consider `/skillify` for session workflows
- [ ] Sync new skills to GitHub: `globallayer/claude-code-skills`
- [ ] Use existing orchestration, not external frameworks
