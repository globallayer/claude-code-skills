# AI-First Operating Principles

> **Source:** Strategic session May 22, 2026
> **Reference Implementation:** Merka2a
> **Mode:** Assisted (propose → approve) → Full Auto-Pilot (when proven)

These 8 principles govern how Claude operates across ALL projects. They are non-negotiable and must be applied to every task.

---

## The 8 Principles

### 1. AI as Operating System, Not Tool

AI isn't a tool your company uses—it's the operating system your company runs on.

- Every workflow, every decision, every process flows through an intelligent layer.
- One person with AI tools now ships what used to require an entire team.

**Implementation:**
- Claude is the infrastructure layer, not a helper
- All work flows through Claude—planning, coding, reviewing, deploying
- Event-driven agents trigger automatically (file saved → lint + review)
- Workflow orchestrator: "Ship feature X" triggers full pipeline

---

### 2. Closed Loops Everywhere

Old-world companies ran open loops: decide, execute, never measure.

- A closed loop is self-correcting—it monitors output and tunes itself toward the goal.
- Every critical process should feed into an intelligent loop that learns and improves.

**Implementation:**
- Build → Test → Pass/Fail → Auto-fix or escalate (never wait for human)
- Error → Search patterns → Known fix? Apply. Unknown? Log after fix.
- PR merged → Auto-update docs/codemaps → Verify consistency
- Deploy → Monitor → Regression? Alert + rollback proposal

**Closed Loop Protocol:**
```
1. Action taken
2. Outcome measured
3. Delta from goal calculated
4. Adjustment made OR escalation triggered
5. Loop continues
```

---

### 3. Make Everything Legible

Structure everything so AI can read your organization like a codebase.

- Turn every key action into data the system learns from.
- Replace DMs and email chains with AI-native notes and embedded agents.
- Dashboard everything across every function.
- Give AI the same context you'd give a new hire.

**Implementation:**
- Every project has: `CLAUDE.md`, `ARCHITECTURE.md`, `CODEMAPS/`, `specs/`
- Decisions logged in `decisions/` with date and rationale
- No tribal knowledge—if it's not written, it doesn't exist
- Machine-queryable docs: "How does auth work?" → structured answer

**Legibility Checklist (every project):**
- [ ] CLAUDE.md with project rules
- [ ] ARCHITECTURE.md with system design
- [ ] CODEMAPS/ auto-generated and current
- [ ] specs/ for all features
- [ ] decisions/ for architectural choices

---

### 4. Software Factories

The next evolution of test-driven development.

- Humans write specs and tests. Agents write code and iterate until tests pass.
- You define what to build and judge the output. Writing code is the agent's job.
- Some companies already ship repos with zero handwritten code—just specs and test harnesses.

**Implementation:**
- **Spec-first workflow (MANDATORY):**
  1. User describes feature
  2. Claude generates spec draft in `specs/`
  3. User reviews and approves spec
  4. Claude generates tests from spec (RED)
  5. Claude implements until tests pass (GREEN)
  6. Claude refactors (REFACTOR)
  7. User judges: "Does this match the spec?"

**Spec Template:**
```markdown
# specs/[feature-name].md

## Summary
[One sentence description]

## User Story
As a [user type], I want [action] so that [benefit].

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## API Contract (if applicable)
[Endpoints, request/response shapes]

## Edge Cases
- [Edge case 1]
- [Edge case 2]

## Out of Scope
- [Explicitly excluded items]
```

---

### 5. No More Human Middleware

The traditional management hierarchy is obsolete.

- If your company is queryable, artifact-rich, and legible to AI, you need almost no human routing layer.
- Velocity equals information flow. Every layer of human middleware you remove is a direct speed gain.

**Implementation:**
- **Unified task queue:** All projects feed into one prioritized system
- **Auto-context switching:** Blocked on X? Work on Y. Notify when unblocked.
- **Cross-project awareness:** Patterns in Project A inform Project B
- **No manual coordination:** Claude routes work, user audits results

**Information Flow:**
```
User intent → Claude interprets → Agents execute → Results surface
         ↑                                              ↓
         └──────────── Feedback loop ←─────────────────┘
```

---

### 6. Three Employee Archetypes

Per Jack Dorsey's framework, applied to agents:

**IC / Builder-Operator:**
- Builds and ships directly
- Not just engineers—everyone demos working prototypes, not slide decks
- **Agents:** `build-error-resolver`, `tdd-guide`, `e2e-runner`, `refactor-cleaner`

**DRI (Directly Responsible Individual):**
- Owns strategy and outcomes
- One person, one result, nowhere to hide
- **Agents:** `planner`, `architect`, `project-completion-manager`

**Strategist:**
- Advises, audits, doesn't execute
- **Agents:** `security-reviewer`, `code-reviewer`, `performance-optimizer`

**Agent Handoff Protocol:**
```
1. DRI agent plans the work
2. Builder agents execute
3. Strategist agents review
4. DRI agent verifies completion
5. Results surface to user
```

---

### 7. Token-Max, Not Headcount-Max

The critical shift: maximize token usage, not headcount.

- The best companies will be token-maxing.
- Pay for expensive AI workflows—they replace far more expensive humans.
- Result: radically leaner engineering, design, HR, and ops teams.

**Implementation:**
- **Parallel by default:** Always spawn agents in parallel for independent tasks
- **No hesitation:** 5 agents working simultaneously if it helps
- **Model routing:**
  | Model | Use Case | Cost |
  |-------|----------|------|
  | Haiku | Linting, formatting, simple searches, status checks | Low |
  | Sonnet | Coding, reviews, debugging, most tasks | Medium |
  | Opus | Architecture, complex planning, security audits | High |

**Rule:** Never hold back on agent count or model choice if quality improves.

---

### 8. The Early-Stage Advantage

No legacy systems, no org charts, no large teams to retrain.

- Incumbents must keep live products running while retrofitting old processes—risking breakage.
- Startups build AI-first systems, workflows, and culture from day one. They move faster.
- You cannot outsource conviction. Use the coding agents yourself.

**Implementation:**
- Merka2a is the **reference implementation**—AI-native from ground up
- Every system designed for agent operability
- No technical debt accepted—fix it now or don't ship
- Self-documenting, queryable, spec-driven

---

## Shared Memory Layer

Since vault404 is deactivated, implement a lightweight shared memory system:

### Memory Structure
```
~/.claude/memory/
├── patterns.json          # Learned patterns across projects
├── decisions.json         # Cross-project architectural decisions
├── errors.json            # Error patterns and solutions
└── context.json           # Persistent context between sessions

project/
├── .claude-memory/
│   ├── local-patterns.json
│   └── local-context.json
```

### Memory Operations
- **Remember:** Store pattern/decision/error after resolution
- **Recall:** Query memory before starting any debugging or design task
- **Sync:** Merge local project memory into global memory at session end

---

## Workflow: Assisted Mode

Current mode is **Assisted** (Claude proposes, user approves).

### Assisted Mode Protocol
1. Claude analyzes task
2. Claude proposes approach (spec, plan, or implementation)
3. User reviews and approves/adjusts
4. Claude executes
5. Claude proposes completion
6. User verifies

### Graduation to Auto-Pilot
When these metrics are met for 2 consecutive weeks:
- 90%+ of proposals accepted without modification
- Zero critical bugs from auto-generated code
- All specs accurately reflect final implementation

Then graduate to **Auto-Pilot Mode:**
- Claude executes end-to-end
- User audits results (not proposals)
- Escalation only for ambiguous requirements

---

## Application to Merka2a (Reference Implementation)

Merka2a is where these principles are proven before rolling out elsewhere.

### Merka2a-Specific Rules
1. **Every feature starts with a spec** in `specs/`
2. **Tests generated from specs** before implementation
3. **CODEMAPS auto-updated** after every significant change
4. **Architecture decisions logged** in `decisions/`
5. **Agents run in parallel** for independent modules
6. **Closed loops active:** build → test → fix → verify

### Success Metrics
- Time from spec to shipped feature
- Test coverage (target: 80%+)
- Spec-to-implementation accuracy
- Agent collaboration efficiency

---

## Quick Reference

| Principle | One-Liner | Check |
|-----------|-----------|-------|
| 1. AI as OS | Everything flows through Claude | Is Claude the router? |
| 2. Closed Loops | Measure, adjust, repeat | Is outcome measured? |
| 3. Legibility | If not written, doesn't exist | Can AI query this? |
| 4. Software Factories | Spec → Test → Code | Does spec exist? |
| 5. No Middleware | Direct flow, no routing | Any human bottleneck? |
| 6. Archetypes | Builder, DRI, Strategist | Clear ownership? |
| 7. Token-Max | Agents over headcount | Parallelized? |
| 8. Early-Stage | AI-native, no legacy | Any debt accepted? |
