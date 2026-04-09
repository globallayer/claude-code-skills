# Claude Code Integrations Plan

## Conflict Analysis

### Current System Inventory

| Component | Count | Location |
|-----------|-------|----------|
| Skills | 1,424 | `~/.claude/skills/` (Antigravity-installed) |
| Agents | 32 | `~/.claude/agents/` |
| Commands | 65 | `~/.claude/commands/` |
| Rules | 78 | `~/.claude/rules/` |
| Plugins | 24 | Via settings.json |

### Potential Conflicts

#### 1. claude-skillify vs /skill-create

| Tool | Source | Analyzes | Output |
|------|--------|----------|--------|
| `/skill-create` | Existing command | Git history | SKILL.md from code patterns |
| `/skillify` | Plugin to install | Conversation history | SKILL.md from workflows |

**Verdict: NO CONFLICT** - Complementary tools
- Use `/skill-create` for code pattern extraction from repos
- Use `/skillify` for workflow capture from sessions

---

#### 2. skillpm vs Antigravity

| Tool | Method | Skills Location |
|------|--------|-----------------|
| Antigravity | Marketplace bulk install | `~/.claude/skills/` |
| skillpm | npm-based with dependencies | `~/.claude/skills/` (same) |

**Verdict: POTENTIAL CONFLICT**
- Both write to same directory
- skillpm may overwrite Antigravity skills with same name

**Mitigation:**
- Check for existing skill before `skillpm install`
- Use skillpm only for skills NOT in Antigravity collection
- Prefer Antigravity for bulk, skillpm for dependency-aware installs

---

#### 3. KAIROS vs Existing Orchestration

| System | Agents | Method |
|--------|--------|--------|
| Existing | 32 general-purpose | `/team-create`, `/orchestrate`, Task tool |
| KAIROS | 7 SDLC-specific | Filesystem mailbox, daemon mode |

**Verdict: SIGNIFICANT OVERLAP**

Existing commands that overlap with KAIROS:
- `/team-create` - Creates coordinated agent teams
- `/orchestrate` - Sequential workflows (feature, bugfix, refactor, security)
- `/loop-start`, `/loop-status` - Daemon-like continuous operation
- `~/.claude/teams/` - Already has team infrastructure

**Recommendation: DO NOT INSTALL KAIROS agents**
- Existing system already has superior orchestration
- KAIROS would duplicate functionality
- Instead: Document KAIROS patterns as reference only

---

## Installation Decisions

### ✅ SAFE TO INSTALL

#### 1. claude-skillify (Plugin)
```bash
/plugin marketplace add 0xMH/claude-skillify
```
**Reason:** Complements `/skill-create` - different analysis source

**Usage differentiation:**
- `/skill-create` → Extract patterns from git commits
- `/skillify` → Capture workflows from conversations

---

### ⚠️ INSTALL WITH CAUTION

#### 2. skillpm (npm package)
```bash
npm install -g skillpm
```

**Pre-install check:**
```bash
# Before installing any skill, verify it doesn't exist
ls ~/.claude/skills/ | grep -i "<skill-name>"
```

**Safe usage:**
```bash
# Only install skills not in Antigravity collection
npx skillpm install <skill-name>
```

**Avoid:**
- Installing skills that already exist via Antigravity
- Using `skillpm` for bulk installs (use Antigravity instead)

---

### ❌ DO NOT INSTALL

#### 3. KAIROS Agents
**Reason:** Conflicts with existing superior orchestration system

**Instead, reference KAIROS patterns:**
- 7-agent SDLC workflow concept → Use existing `/orchestrate feature`
- Filesystem mailbox → Already have `~/.claude/teams/`
- Daemon mode → Use existing `/loop-start`

---

## Integration Strategy

### Workflow Capture (NEW)

After completing repeatable work:
1. **For code patterns:** Run `/skill-create`
2. **For session workflows:** Run `/skillify` (after plugin install)
3. **Sync to GitHub:** Push to `globallayer/claude-code-skills`

### Skill Installation Priority

1. **First:** Check existing `~/.claude/skills/` (1,424 Antigravity skills)
2. **Second:** Search npm `agent-skill` keyword
3. **Third:** Use `skillpm install` only if not in Antigravity

### Multi-Agent Orchestration

Use existing system:
```bash
/orchestrate feature "Add user authentication"
/team-create --name auth --goal "Build OAuth" --workers "planner:opus,security-reviewer,code-reviewer"
/loop-start                    # For autonomous operation
```

---

## Safe Installation Commands

```bash
# 1. Install claude-skillify plugin (SAFE)
/plugin marketplace add 0xMH/claude-skillify

# 2. Install skillpm globally (CAUTION - check before each use)
npm install -g skillpm

# 3. KAIROS - DO NOT INSTALL, use existing orchestration instead
```

---

## Post-Install Verification

```bash
# Verify no skill overwrites
ls ~/.claude/skills/ | wc -l   # Should still be ~1424

# Verify plugins
cat ~/.claude/settings.json | grep skillify

# Test commands
/skillify --help
/skill-create --help
/orchestrate --help
```

---

## Sources

- [claude-skillify](https://github.com/0xMH/claude-skillify) - Workflow capture (INSTALL)
- [skillpm](https://github.com/sbroenne/skillpm) - Package manager (INSTALL WITH CAUTION)
- [KAIROS Framework](https://github.com/diego81b/kairos-agents-framework) - Reference only (DO NOT INSTALL)
