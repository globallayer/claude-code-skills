# Token-Max Enforcement

> Mechanisms to detect and encourage parallel execution over sequential.

## Enforcement Mechanisms

### 1. Parallel Detection in Hooks

The `observe.sh` hook (continuous learning) tracks tool invocation patterns:

```
Pattern: Sequential Task calls when parallel possible
Detection: 3+ Task calls in sequence with no dependencies
Action: Log observation, suggest parallelization
```

### 2. Model Routing Validation

| Task Complexity | Expected Model | Warning If |
|-----------------|----------------|------------|
| Lint/format | Haiku | Using Sonnet/Opus |
| Code implementation | Sonnet | Using Opus for simple code |
| Architecture | Opus | Using Haiku/Sonnet |

### 3. Session Evaluation

The `evaluate-session.js` hook analyzes:
- Total Task calls
- Parallel vs sequential ratio
- Model usage distribution
- Missed parallelization opportunities

## Pattern Indicators

### Sequential When Parallel Possible (Anti-Pattern)

```
# BAD: Sequential
[Task: code-reviewer] → wait → [Task: security-reviewer] → wait → [Task: typescript-reviewer]

# GOOD: Parallel
[Task: code-reviewer, Task: security-reviewer, Task: typescript-reviewer] (single message)
```

### Model Over-use (Anti-Pattern)

```
# BAD: Using Opus for lint
[Task: opus → "run eslint"]

# GOOD: Using Haiku for lint
[Task: haiku → "run eslint"]
```

## Enforcement Levels

### Observation (Current)
- Track patterns via hooks
- Log to memory layer
- No blocking

### Warning (Recommended)
- Alert user in session summary
- Suggest improvements
- Non-blocking

### Strict (Future)
- Block sequential when parallel detected
- Require explicit override
- Full enforcement

## Implementation Status

| Mechanism | Status | Location |
|-----------|--------|----------|
| Pattern observation | Active | `observe.sh` |
| Session evaluation | Active | `evaluate-session.js` |
| Model routing guide | Documented | `token-max-policy.md` |
| Real-time warning | Not implemented | Future |
| Strict blocking | Not implemented | Future |

## Metrics Tracked

| Metric | Target | Location |
|--------|--------|----------|
| Parallel ratio | >80% | Session metrics |
| Haiku usage (simple tasks) | >50% | Cost tracker |
| Sequential anti-patterns | <10% | Session evaluation |

## Integration with Memory Layer

Enforcement patterns logged to:
- `~/.claude/memory/patterns.json` - Good patterns
- `~/.claude/memory/context.json` - Session metrics

## Manual Override

To explicitly run sequentially when parallel isn't appropriate:

```markdown
Note: Running these sequentially because [step 2 depends on step 1 output].
```

This signals intentional sequential execution and won't be flagged.

## Recommendations

1. **Default to parallel** - When in doubt, parallelize
2. **Check dependencies** - Only sequential if output needed
3. **Use right model** - Haiku for simple, Sonnet for code, Opus for architecture
4. **Batch Task calls** - Single message with multiple Task invocations
5. **Review session metrics** - Check parallelization ratio at session end
