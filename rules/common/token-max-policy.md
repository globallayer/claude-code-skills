# Token-Max Policy

> **Principle #7:** Maximize token usage, not headcount. Pay for expensive AI workflows — they replace far more expensive humans.

## Core Rule

**Parallel by default.** If tasks are independent, spawn agents in parallel. Never work sequentially when parallel is possible.

## Model Routing

| Model | Cost | Use For | Examples |
|-------|------|---------|----------|
| **Haiku 4.5** | Low | Fast, simple tasks | Linting, formatting, simple searches, status checks, quick lookups |
| **Sonnet 4.6** | Medium | Most coding work | Implementation, reviews, debugging, refactoring, test writing |
| **Opus 4.5** | High | Deep reasoning | Architecture decisions, complex planning, security audits, research |

## Parallel Execution Rules

### ALWAYS Parallelize

1. **Independent file operations** - Reading 5 files? 5 parallel reads.
2. **Independent searches** - Searching for 3 patterns? 3 parallel searches.
3. **Independent agents** - Security + code review? Launch both.
4. **Independent tests** - Multiple test suites? Parallel execution.

### NEVER Parallelize

1. **Sequential dependencies** - Write file → then read it
2. **State mutations** - Git add → then commit → then push
3. **Conversation flow** - Ask question → wait for answer

## Agent Spawn Guidelines

### Spawn Aggressively

```
# GOOD: 3 agents in parallel for independent tasks
Task 1: security-reviewer → auth module
Task 2: code-reviewer → API endpoints
Task 3: typescript-reviewer → type definitions
```

### Don't Hold Back

```
# If 5 agents would help, spawn 5 agents
# If Opus is needed, use Opus
# Cost efficiency comes from speed, not conservation
```

## Task Tool Best Practices

When using the Task tool:

1. **Batch independent calls** - Single message, multiple Task invocations
2. **Specify model** - Use `model: "haiku"` for simple tasks
3. **Use background** - Set `run_in_background: true` for long tasks
4. **No placeholders** - Never guess dependent values

## Examples

### Good: Parallel Agent Launch

```markdown
I need to:
1. Review security of auth module
2. Check code quality of API routes
3. Validate TypeScript types

Launching 3 agents in parallel...
[Task: security-reviewer, Task: code-reviewer, Task: typescript-reviewer]
```

### Bad: Sequential When Parallel Possible

```markdown
First, let me review security...
[Task: security-reviewer]
Now let me check code quality...
[Task: code-reviewer]
Finally, let me validate types...
[Task: typescript-reviewer]
```

### Good: Model Routing

```markdown
# Quick lint check (Haiku)
Task: haiku → "Run eslint and report issues"

# Implementation (Sonnet)
Task: sonnet → "Implement the authentication flow"

# Architecture review (Opus)
Task: opus → "Review system design for scalability concerns"
```

## Metrics to Track

- Parallel vs sequential execution ratio (target: 80%+ parallel)
- Model routing accuracy (right model for right task)
- Agent spawn hesitation (should be zero)

## Anti-Patterns to Avoid

1. **Sequential fallback** - Working one task at a time when parallelization is possible
2. **Model conservation** - Using Haiku when Sonnet/Opus is needed
3. **Agent hesitation** - Not spawning agents because "it might be overkill"
4. **Placeholder guessing** - Making up values instead of waiting for results

## Integration with Other Principles

- **Principle #1 (AI as OS)**: Token-max enables the infrastructure layer
- **Principle #2 (Closed Loops)**: Parallel agents enable faster feedback loops
- **Principle #6 (Archetypes)**: Multiple agents = multiple specialists working together
