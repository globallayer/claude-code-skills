---
name: standup-post
description: Use when the user asks for a standup, daily update, status report, or "what did I work on". Aggregates GitHub activity, task trackers, and git commits to generate a formatted standup. Also use at the start of each day or session to summarize recent work.
risk: low
source: local
---

# Standup Post Generator

Generates formatted daily standups by aggregating activity from multiple sources.

## When to Use

- User asks "what did I work on yesterday/today?"
- User requests a standup or daily update
- Start of a new coding session (summarize previous work)
- User asks for status report or progress update

## Data Sources

1. **Git commits** - Recent commits from all repos in workspace
2. **GitHub PRs** - Open, merged, and reviewed PRs
3. **GitHub Issues** - Created, closed, or commented issues
4. **Task list** - Any TodoWrite tasks from previous sessions

## Workflow

### Step 1: Gather Git Activity

```bash
# Last 24 hours of commits across all repos
git log --all --oneline --since="24 hours ago" --author="$(git config user.name)" 2>/dev/null

# Or last N commits if time-based is empty
git log --all --oneline -10 --author="$(git config user.name)" 2>/dev/null
```

### Step 2: Gather GitHub Activity

```bash
# PRs authored (open and recently merged)
gh pr list --author=@me --state=all --limit=10

# PRs reviewed
gh pr list --search="reviewed-by:@me" --state=all --limit=5

# Issues
gh issue list --author=@me --state=all --limit=10
```

### Step 3: Check Session State

Read `~/.claude/SESSION_STATE.md` for context from previous sessions.

### Step 4: Format Output

Use the template in `templates/standup.md` for consistent formatting.

## Output Format

```markdown
## Standup - [DATE]

### Completed
- [What was finished]

### In Progress
- [What's being worked on]

### Blocked / Needs Input
- [Any blockers]

### Next Up
- [Planned next tasks]

---
*Activity: X commits, Y PRs, Z issues*
```

## Gotchas

1. **Empty git log** - If no commits in 24h, expand to 48h or show last 5 commits
2. **Multiple repos** - Run git commands in each project directory, not just CWD
3. **GitHub auth** - Ensure `gh auth status` passes before querying
4. **Time zones** - Use `--since` with care; prefer relative times ("24 hours ago")
5. **Private repos** - `gh` commands may fail silently for repos without access

## Data Persistence

Store standup history in `${CLAUDE_PLUGIN_DATA}/standups/`:

```
standups/
├── 2026-04-08.md
├── 2026-04-07.md
└── history.json   # Structured log of all standups
```

On each run:
1. Read previous standups to determine what's NEW
2. Generate standup for today
3. Save to dated file
4. Append to history.json

## Configuration

If `config.json` exists in this skill directory, use it:

```json
{
  "slack_channel": "#team-standups",
  "include_repos": ["marketplace", "axm-web", "ChartCrack"],
  "exclude_repos": ["node_modules", ".git"],
  "lookback_hours": 24,
  "format": "markdown"
}
```

If config is missing, ask user for preferences on first run.

## Integration with Other Skills

- After generating standup, offer to post via `slack-automation` if configured
- Can be combined with `weekly-recap` for longer summaries

## Example Output

```markdown
## Standup - April 8, 2026

### Completed
- Deployed Merka2a backend to Railway (commit: 482e30a)
- Fixed authentication flow in axm-web
- Merged PR #42: Add Stripe webhook handlers

### In Progress
- Phase 2: Public Face & First Partners (Merka2a)
- ChartCrack mobile game development

### Blocked / Needs Input
- None currently

### Next Up
- Create landing page for merka2a.com
- Implement partner onboarding flow

---
*Activity: 4 commits, 2 PRs merged, 1 issue closed*
```
