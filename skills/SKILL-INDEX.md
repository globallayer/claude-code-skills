# Skill Index by Category

Quick reference for finding the right skill. Based on Anthropic's 9-category skill taxonomy.

---

## 1. Library & API References

Skills that explain how to use a library, CLI, or SDK correctly.

| Skill | Purpose |
|-------|---------|
| `stripe-integration` | Stripe payments, webhooks, subscriptions |
| `supabase-automation` | Supabase database, auth, storage |
| `nextjs-best-practices` | Next.js App Router patterns |
| `expo-deployment` | Expo/React Native deployment |
| `prisma-expert` | Prisma ORM patterns |
| `drizzle-orm-expert` | Drizzle ORM patterns |
| `tailwind-patterns` | Tailwind CSS utilities |

---

## 2. Product Verification

Skills for testing and verifying code behavior.

| Skill | Purpose |
|-------|---------|
| `e2e-testing` | End-to-end test patterns |
| `playwright-skill` | Playwright browser automation |
| `tdd` | Test-driven development workflow |
| `e2e` | E2E test runner agent |
| `verification-loop` | Automated verification |

---

## 3. Data Retrieval & Analysis

Skills for connecting to data and monitoring systems.

| Skill | Purpose |
|-------|---------|
| `grafana-dashboards` | Grafana dashboard creation |
| `datadog-automation` | Datadog monitoring setup |
| `amplitude-automation` | Amplitude analytics |
| `mixpanel-automation` | Mixpanel analytics |

---

## 4. Business Processes & Automation

Skills that automate repetitive workflows.

| Skill | Purpose |
|-------|---------|
| `standup-post` | **[NEW]** Daily standup generation |
| `commit` | Git commit with conventions |
| `create-pr` | Pull request creation |
| `create-branch` | Branch creation |
| `slack-automation` | Slack messaging |

---

## 5. Code Templates & Scaffolding

Skills for generating framework boilerplate.

| Skill | Purpose |
|-------|---------|
| `nextjs-app-router-patterns` | Next.js project structure |
| `react-patterns` | React component templates |
| `fastapi-templates` | FastAPI project scaffold |
| `expo-api-routes` | Expo API routes |

---

## 6. Code Quality & Review

Skills that enforce quality standards.

| Skill | Purpose |
|-------|---------|
| `code-reviewer` | General code review |
| `security-reviewer` | Security analysis |
| `typescript-reviewer` | TypeScript-specific review |
| `python-reviewer` | Python-specific review |
| `rust-reviewer` | Rust-specific review |
| `careful` | **[NEW]** Destructive command protection |

---

## 7. CI/CD & Deployment

Skills for shipping and deploying code.

| Skill | Purpose |
|-------|---------|
| `deploy-railway` | **[NEW]** Railway deployments |
| `pr-babysitter` | **[NEW]** PR monitoring & auto-merge |
| `vercel-deployment` | Vercel deployments |
| `github-actions-templates` | GitHub Actions workflows |

---

## 8. Runbooks

Skills for investigation and debugging.

| Skill | Purpose |
|-------|---------|
| `debugger` | General debugging |
| `error-detective` | Error investigation |
| `build-error-resolver` | Build failure resolution |
| `systematic-debugging` | Structured debugging approach |

---

## 9. Infrastructure Operations

Skills for maintenance and operational procedures.

| Skill | Purpose |
|-------|---------|
| `aws-cost-cleanup` | AWS cost optimization |
| `refactor-cleaner` | Dead code removal |
| `database-migrations` | Database migration management |

---

## Custom Skills (Created This Session)

| Skill | Category | Description |
|-------|----------|-------------|
| `standup-post` | Business Process | Aggregates GitHub + tasks for daily standup |
| `deploy-railway` | CI/CD | Railway deployment with health checks |
| `careful` | Code Quality | Blocks destructive commands (rm -rf, DROP, etc.) |
| `pr-babysitter` | CI/CD | Monitors PR, retries flaky tests, auto-merges |

---

## Quick Reference by Task

| Task | Skill to Use |
|------|-------------|
| "What did I work on?" | `/standup-post` |
| "Deploy to Railway" | `/deploy-railway` |
| "Working with production" | `/careful` |
| "Get this PR merged" | `/pr-babysitter` |
| "Review my code" | `/code-reviewer` |
| "Check for security issues" | `/security-reviewer` |
| "Write tests first" | `/tdd` |
| "Create a commit" | `/commit` |
| "Create a PR" | `/create-pr` |

---

## Skills with Gotchas Sections

These skills have comprehensive gotchas sections for common mistakes:

- `stripe-integration` - 14 gotchas (webhooks, amounts, idempotency)
- `supabase-automation` - 15 gotchas (RLS, pooling, array syntax)
- `nextjs-best-practices` - 17 gotchas (server/client, hydration)
- `expo-deployment` - 16 gotchas (OTA vs native, signing keys)

---

## Skill Folder Structure

Well-structured skills follow this pattern:

```
skill-name/
├── SKILL.md          # Main instructions
├── config.json       # Configurable settings
├── templates/        # Output templates
├── scripts/          # Helper scripts
├── examples/         # Usage examples
└── gotchas.md        # Common mistakes (optional)
```
