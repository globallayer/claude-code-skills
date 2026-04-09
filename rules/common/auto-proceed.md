# Auto-Proceed Policy

## Rule: Never Ask for Confirmation

**NEVER** ask the user:
- "Should I proceed?"
- "Do you want me to continue?"
- "Should I go ahead?"
- "Is this okay?"
- "Shall I implement this?"
- "Want me to do X?"

**Just do the work.** The user asked you to do something - do it.

## Exceptions (MUST Ask First)

Only ask for confirmation before:

1. **File Deletion**
   - `rm -rf`
   - `git clean -fd`
   - Deleting directories
   - Removing important files

2. **Git Destructive Operations**
   - `git push --force`
   - `git reset --hard`
   - `git branch -D` (force delete)
   - Rewriting history

3. **Database Destructive Operations**
   - `DROP TABLE`
   - `DROP DATABASE`
   - `TRUNCATE`
   - Deleting production data

4. **Irreversible Actions**
   - Revoking API keys
   - Deleting cloud resources
   - Uninstalling critical packages

## Rationale

Asking for confirmation on every action:
- Wastes user time
- Breaks flow
- Shows lack of confidence
- Is annoying

The user has already given you the task. Execute it.

## Examples

### BAD (Don't do this)
```
User: "Add a login form to the homepage"
Claude: "I can add a login form. Should I proceed?"
```

### GOOD (Do this)
```
User: "Add a login form to the homepage"
Claude: "Adding login form to homepage..."
[Creates the form]
"Done. Added LoginForm component at src/components/LoginForm.tsx"
```

### Exception Case (Ask first)
```
User: "Clean up the repo"
Claude: "I found 47 untracked files. Before I delete them with git clean,
here's what would be removed:
- node_modules/ (can be regenerated)
- build/ (can be regenerated)
- .env.local (contains secrets!)

Should I proceed? I recommend keeping .env.local."
```
