# Skill Router Agent

## Purpose

Analyze user intent and context to automatically route to appropriate skills. This agent should be consulted when starting new tasks to ensure the right skills are invoked.

---

## UI Design (UPDATED - Better Than /frontend-design)

### Priority 1: Figma Plugin (PREFERRED)
When user has a Figma URL or mentions Figma:
- `/implement-design` - Extracts design context, tokens, generates pixel-perfect code
- `/create-design-system-rules` - Creates rules file for consistent generation

### Priority 2: Visual Diagrams
- `/excalidraw-diagram` - Architecture diagrams, wireframes, flow charts

### Priority 3: Fallback Only
- `/frontend-design` - ONLY when no Figma design exists

**Rule:** If user provides Figma URL, ALWAYS use `/implement-design` first.

---

## Browser Automation (UPDATED - Faster Options)

### Priority 1: agent-browser CLI (FASTEST)
Fast headless browser with accessibility tree snapshots:

```bash
# Navigate and get state
agent-browser open https://example.com
agent-browser snapshot -i --json

# Interact using refs from snapshot
agent-browser click @e2
agent-browser fill @e3 "text"

# Save/load auth state (skip logins)
agent-browser state save auth.json
agent-browser state load auth.json

# Screenshots
agent-browser screenshot page.png
```

**Features:**
- Session isolation (`--session admin`)
- State persistence (skip login flows)
- Network mocking
- Multi-tab support
- 10x faster than browser-use

### Priority 2: superpowers-chrome
When visual inspection or debugging needed:
- `/superpowers-chrome:browsing` - Chrome DevTools with vision

### Priority 3: Playwright Plugin
For E2E testing:
- `/playwright` - Full Playwright framework

### Priority 4: Fallback
- `/browser-use` - SLOW, only when others unavailable

---

## Manus-Like Workflow

For autonomous browser work with accounts/forms/roaming:

```bash
# 1. Open and snapshot
agent-browser open https://site.com/signup
agent-browser snapshot -i --json

# 2. Fill form using refs
agent-browser fill @e1 "email@example.com"
agent-browser fill @e2 "SecurePass123!"
agent-browser click @e3  # Submit button

# 3. Wait and verify
agent-browser wait --load networkidle
agent-browser snapshot -i --json

# 4. Save session for reuse
agent-browser state save myaccount.json

# 5. Screenshot for verification
agent-browser screenshot success.png
```

---

## Code Quality Routing

| Context | Skills |
|---------|--------|
| TypeScript/JavaScript | `/typescript-reviewer`, `/code-reviewer` |
| Python | `/python-reviewer`, `/code-reviewer` |
| Go | `/go-reviewer`, `/code-reviewer` |
| Rust | `/rust-reviewer`, `/code-reviewer` |
| C++ | `/cpp-reviewer`, `/code-reviewer` |
| Java | `/java-reviewer`, `/code-reviewer` |
| Kotlin | `/kotlin-reviewer`, `/code-reviewer` |

---

## Security Routing

| Context | Skills |
|---------|--------|
| Auth/authorization code | `/security-reviewer`, `/security-audit` |
| User input handling | `/security-audit` |
| Database queries | `/security-audit`, `/database-reviewer` |
| Payment/financial code | `/stripe-integration`, `/security-audit` |
| Before any commit | `/security-audit` |

---

## Development Workflow Routing

| Context | Skills |
|---------|--------|
| New feature request | `/planner`, `/architect` |
| Bug fix | `/tdd-guide`, `/debugger` |
| Architecture question | `/architect`, `/architecture` |
| Build fails | `/build-error-resolver` |
| Complex refactoring | `/planner`, `/refactor-cleaner` |

---

## Frontend Development Routing

| Context | Skills |
|---------|--------|
| UI with Figma URL | `/implement-design` (ALWAYS FIRST) |
| UI without Figma | `/excalidraw-diagram` then `/frontend-design` |
| Next.js | `/nextjs-best-practices` |
| React patterns | `/react-best-practices`, `/react-patterns` |
| Tailwind CSS | `/tailwind-patterns` |
| React Native | `/react-native-architecture` |

---

## Backend Development Routing

| Context | Skills |
|---------|--------|
| API design | `/api-design-principles` |
| API documentation | `/api-documentation` |
| Node.js patterns | `/nodejs-backend-patterns` |
| Database work | `/database-design`, `/postgres-best-practices` |

---

## Testing Routing

| Context | Skills |
|---------|--------|
| Writing tests | `/tdd-guide`, `/tdd` |
| E2E tests | `/e2e-runner`, `/e2e` |
| Test coverage | `/test-coverage` |

---

## Research Routing

| Context | Skills |
|---------|--------|
| Library/framework docs | `/docs-lookup` |
| Web search needed | `/deep-research` |
| Market research | `/market-research` |

---

## Skill Priority Order

1. **Pre-work:** `/implement-design`, `/planner`, `/architect`
2. **Implementation:** `/tdd-guide`, `/api-design-principles`
3. **Review:** `/code-reviewer`, `/security-reviewer`
4. **Post-work:** `/documentation`, `/simplify`

---

## Automatic Triggers

| Action | Trigger Skill |
|--------|---------------|
| Before ANY UI code | `/implement-design` (if Figma) or `/excalidraw-diagram` |
| After completing code | `/code-reviewer`, `/simplify` |
| Auth/payment code | `/security-reviewer` |
| Before commit | `/security-audit` |
