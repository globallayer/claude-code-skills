# File Change Auto-Triggers

> PostToolUse hooks that automatically run checks after file modifications.

## Active Triggers (Already Implemented)

The following triggers are already active in `~/.claude/hooks/hooks.json`:

### Quality Gate (PostToolUse: Edit|Write|MultiEdit)
- **Hook:** `quality-gate.js`
- **Async:** Yes (non-blocking)
- **Timeout:** 30s
- **Action:** Runs quality checks after file edits

### Auto-Format (PostToolUse: Edit)
- **Hook:** `post-edit-format.js`
- **Mode:** Strict only
- **Action:** Auto-formats JS/TS files using Biome or Prettier

### TypeScript Check (PostToolUse: Edit)
- **Hook:** `post-edit-typecheck.js`
- **Mode:** Strict only
- **Action:** Runs TypeScript type checking on .ts/.tsx files

### Console.log Warning (PostToolUse: Edit)
- **Hook:** `post-edit-console-warn.js`
- **Mode:** Standard + Strict
- **Action:** Warns about console.log statements

### Observation Capture (PostToolUse: *)
- **Hook:** `observe.sh`
- **Async:** Yes (non-blocking)
- **Action:** Captures tool use for continuous learning

## Trigger Matrix

| File Type | Format | TypeCheck | QualityGate | ConsoleWarn |
|-----------|--------|-----------|-------------|-------------|
| `.ts` | Yes | Yes | Yes | Yes |
| `.tsx` | Yes | Yes | Yes | Yes |
| `.js` | Yes | No | Yes | Yes |
| `.jsx` | Yes | No | Yes | Yes |
| `.json` | Yes | No | Yes | No |
| `.md` | No | No | No | No |
| `.css` | No | No | Yes | No |

## Configuration

### Enable/Disable Modes

Hooks run based on mode flags in `everything-claude-code`:

| Mode | Environment | Hooks Active |
|------|-------------|--------------|
| `minimal` | Quick fixes | Session only |
| `standard` | Normal development | Most hooks |
| `strict` | Production code | All hooks |

### Skip Specific Hooks

```bash
# Skip all file-change triggers
export ECC_SKIP_FILE_HOOKS=1

# Skip format only
export ECC_SKIP_FORMAT=1

# Skip typecheck only
export ECC_SKIP_TYPECHECK=1
```

## Adding Custom Triggers

To add a new file-change trigger, add to `hooks.json`:

```json
{
  "matcher": "Edit|Write",
  "hooks": [
    {
      "type": "command",
      "command": "node \"${CLAUDE_PLUGIN_ROOT}/scripts/hooks/my-custom-hook.js\"",
      "async": true,
      "timeout": 30
    }
  ],
  "description": "My custom file change trigger"
}
```

## Integration with Agent Handoff

File change triggers can invoke agents:

1. **quality-gate.js** detects issues → suggests code-reviewer
2. **typecheck fails** → suggests build-error-resolver
3. **security pattern detected** → suggests security-reviewer

## Performance Impact

| Hook | Avg Time | Blocking |
|------|----------|----------|
| quality-gate | 2-5s | No |
| format | 0.5-1s | Yes |
| typecheck | 1-3s | Yes |
| console-warn | 0.1s | Yes |
| observe | 0.2s | No |

Total overhead for typical edit: ~3-5 seconds (mostly async)
