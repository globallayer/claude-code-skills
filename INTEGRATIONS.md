# Claude Code Integrations Plan

## 1. Skillify (claude-skillify)

**What it does:** Captures repeatable session workflows into reusable SKILL.md files.

**Source:** https://github.com/0xMH/claude-skillify

**Installation:**
```bash
/plugin marketplace add 0xMH/claude-skillify
```

**Usage:**
```bash
/skillify                              # Analyze current session
/skillify cherry-pick workflow         # With description hint
```

**When to use:**
- After completing a repeatable process (deploy, PR review, migration)
- When you find yourself doing the same multi-step workflow twice
- To document complex procedures for future reuse

**Integration points:**
- Run `/skillify` at end of sessions with repeatable work
- Generated skills go to `~/.claude/skills/`
- Skills sync to `globallayer/claude-code-skills` repo

---

## 2. Skillpm (Package Manager)

**What it does:** npm-based package manager for agent skills with dependency resolution.

**Source:** https://github.com/sbroenne/skillpm | https://skillpm.dev

**Installation:**
```bash
npm install -g skillpm
```

**Commands:**
```bash
npx skillpm install <skill>    # Install skill + dependencies
npx skillpm list               # Show installed skills
npx skillpm init               # Scaffold new skill package
npx skillpm publish            # Publish to npm
```

**When to use:**
- Installing community skills with dependencies
- Publishing skills to npm ecosystem
- Managing MCP server configurations automatically

**Integration points:**
- 90+ skills available with `agent-skill` keyword on npm
- Auto-configures MCP servers from skill dependencies
- Works with Claude, Cursor, VS Code, Codex

---

## 3. KAIROS Framework

**What it does:** Multi-agent SDLC orchestration with 7 specialized subagents.

**Source:** https://github.com/diego81b/kairos-agents-framework | https://kairos-kit.com

**Concept:** Greek for "the right moment" - daemon mode where Claude works autonomously.

**Architecture:**
- 7 specialized subagents in `agents/` directory
- Filesystem-based mailbox: `~/.claude/teams/{team}/mailbox/{agent}.json`
- Forked sub-agent model for isolated background tasks

**Installation:**
```bash
# Copy agents to project
cp -r kairos-agents-framework/agents/ ./agents/
```

**Usage:**
```
"Help me add X feature with KAIROS"
```

**When to use:**
- Complex multi-step features requiring coordination
- Background autonomous development tasks
- Quality-focused development with built-in review cycles

**Integration points:**
- Orchestrates 7 agents automatically per task
- Integrates with existing agent definitions in `~/.claude/agents/`
- Can run as daemon for continuous development

---

## Workflow Automation Rules

### Auto-Skillify Trigger
After completing these workflows, prompt to run `/skillify`:
- Deployment to any platform
- PR creation and review cycles
- Database migrations
- API integrations
- Build/CI fixes

### Skillpm Integration
When user requests a skill that isn't installed:
1. Search npm: `npm search <skill-name> --keywords agent-skill`
2. If found: `npx skillpm install <skill-name>`
3. Skill auto-wires to `~/.claude/skills/`

### KAIROS Activation
Trigger KAIROS orchestration when:
- Feature request spans multiple files/domains
- Task requires research + implementation + testing + review
- User says "with KAIROS" or requests autonomous work
- Complex refactoring or architectural changes

---

## Directory Structure

```
~/.claude/
├── skills/           # 1,424 skills (synced to GitHub)
├── agents/           # 32 agent definitions (synced to GitHub)
├── rules/            # 78 rule files (synced to GitHub)
├── teams/            # KAIROS team mailboxes
│   └── {team}/
│       └── mailbox/
│           └── {agent}.json
└── INTEGRATIONS.md   # This file
```

---

## Sync Commands

```bash
# Sync local to GitHub
cd ~/Claude/claude-code-skills
cp -r ~/.claude/skills/* skills/
cp -r ~/.claude/agents/* agents/
cp -r ~/.claude/rules/* rules/
git add -A && git commit -m "sync" && git push

# Pull from GitHub to local
git pull origin master
cp -r skills/* ~/.claude/skills/
cp -r agents/* ~/.claude/agents/
cp -r rules/* ~/.claude/rules/
```

---

## Sources

- [claude-skillify](https://github.com/0xMH/claude-skillify) - Workflow capture
- [skillpm](https://github.com/sbroenne/skillpm) - Package manager
- [KAIROS Framework](https://github.com/diego81b/kairos-agents-framework) - Multi-agent orchestration
- [Kairos Kit](https://kairos-kit.com) - Orchestration conventions
- [Agent Skills Registry](https://skillpm.dev/registry/) - 90+ npm skills
- [MCP Servers](https://mcpservers.org) - MCP server directory
