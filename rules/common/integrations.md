# External Integrations

## Skillify - Workflow Capture

After completing repeatable workflows, offer to run `/skillify`:
- Deployments (Railway, Vercel, Netlify, etc.)
- PR creation and review cycles
- Database migrations
- API integrations
- Build/CI fixes
- Any multi-step process done twice

## Skillpm - Skill Package Manager

When a skill isn't available locally:
1. Search: `npm search <name> --keywords agent-skill`
2. Install: `npx skillpm install <skill-name>`
3. Skills auto-wire to `~/.claude/skills/`

## KAIROS - Multi-Agent Orchestration

Activate KAIROS orchestration when:
- Feature spans multiple files/domains
- Task needs research + implementation + testing + review
- User explicitly requests "with KAIROS"
- Complex refactoring or architectural changes
- Autonomous background work needed

KAIROS uses 7 specialized subagents coordinated through filesystem mailboxes.

## Integration Checklist

Before ending a session with repeatable work:
- [ ] Offer `/skillify` to capture the workflow
- [ ] Sync new skills to GitHub repo
- [ ] Update `~/.claude/INTEGRATIONS.md` if new patterns emerged
