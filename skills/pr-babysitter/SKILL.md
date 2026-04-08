---
name: pr-babysitter
description: "Monitor a PR through CI/CD, automatically retry flaky tests, resolve merge conflicts, and enable auto-merge when ready. Use when you want hands-off PR management. Trigger with 'babysit PR', 'watch this PR', or 'get this merged'."
risk: medium
source: local
---

# PR Babysitter

Monitors a pull request through CI/CD pipeline, handles flaky tests, resolves merge conflicts, and enables auto-merge when all checks pass.

## When to Use

- After creating a PR that needs to go through CI
- When you want to walk away and let the PR merge itself
- When dealing with flaky tests that need retries
- When merge conflicts keep appearing from active main branch

## Workflow Overview

```
1. Monitor PR status
   ↓
2. If checks fail:
   - Analyze failure type
   - If flaky test → retry
   - If real failure → report and stop
   ↓
3. If merge conflicts:
   - Attempt auto-resolve
   - If complex → report and stop
   ↓
4. If all checks pass:
   - Enable auto-merge
   - Confirm merged
```

## Commands

### Start Babysitting

```bash
# Babysit a specific PR
gh pr view <PR_NUMBER> --json number,title,state,mergeable,statusCheckRollup

# Check current status
gh pr checks <PR_NUMBER>

# Watch for changes (poll every 60 seconds)
gh pr checks <PR_NUMBER> --watch
```

### Handle Flaky Tests

```bash
# Re-run failed checks
gh run rerun <RUN_ID> --failed

# Re-run entire workflow
gh workflow run <WORKFLOW_NAME>

# List recent runs
gh run list --limit 5
```

### Handle Merge Conflicts

```bash
# Check if mergeable
gh pr view <PR_NUMBER> --json mergeable

# Update branch with main
git fetch origin main
git merge origin/main

# Or rebase
git rebase origin/main

# Force push updated branch
git push --force-with-lease
```

### Enable Auto-Merge

```bash
# Enable auto-merge (squash)
gh pr merge <PR_NUMBER> --auto --squash

# Enable auto-merge (merge commit)
gh pr merge <PR_NUMBER> --auto --merge

# Check auto-merge status
gh pr view <PR_NUMBER> --json autoMergeRequest
```

## Babysitting Loop

```
repeat every 60 seconds:
  1. gh pr view <PR> --json state,mergeable,statusCheckRollup

  2. if state == "MERGED":
       exit success "PR merged!"

  3. if state == "CLOSED":
       exit failure "PR was closed"

  4. if mergeable == "CONFLICTING":
       attempt_resolve_conflicts()
       if failed: exit failure "Merge conflicts need manual resolution"

  5. checks = get_check_status()
     if all checks pass:
       enable_auto_merge()
       continue monitoring

     if any check failed:
       if is_flaky_test(check):
         retry_check(check)
         increment retry_count
         if retry_count > MAX_RETRIES:
           exit failure "Max retries exceeded"
       else:
         exit failure "Check failed: {check_name}"

     if checks still running:
       continue monitoring

until: PR merged OR timeout (30 minutes) OR failure
```

## Flaky Test Detection

A test is considered flaky if:

1. **Known flaky pattern** - matches patterns in `config.json`
2. **Intermittent failure** - passed recently on same code
3. **Timeout** - failed due to timeout, not assertion
4. **Infrastructure error** - runner issues, network timeouts

```bash
# Check if test has passed before on this commit
gh run list --commit $(git rev-parse HEAD) --json conclusion
```

## Conflict Resolution Strategy

### Auto-Resolvable

- `package-lock.json` / `pnpm-lock.yaml` - regenerate
- `yarn.lock` - regenerate
- Version bumps in `package.json` - take higher version
- Auto-generated files (types, schemas) - regenerate

### Manual Resolution Required

- Source code conflicts
- Migration conflicts
- Configuration conflicts
- Test conflicts

```bash
# Attempt auto-resolve for lock files
git checkout --theirs package-lock.json
npm install
git add package-lock.json
git commit -m "fix: resolve merge conflict in package-lock.json"
git push
```

## Configuration

Create `config.json` to customize behavior:

```json
{
  "max_retries": 3,
  "poll_interval_seconds": 60,
  "timeout_minutes": 30,
  "flaky_test_patterns": [
    "timeout",
    "ETIMEDOUT",
    "ECONNRESET",
    "socket hang up",
    "net::ERR_CONNECTION"
  ],
  "auto_resolve_files": [
    "package-lock.json",
    "pnpm-lock.yaml",
    "yarn.lock"
  ],
  "merge_method": "squash",
  "delete_branch_after_merge": true
}
```

## Status Reporting

The babysitter reports status at key events:

```
[PR #123] Starting babysitter...
[PR #123] Checks running: lint, test, build
[PR #123] Check failed: test (attempt 1/3)
[PR #123] Retrying failed check...
[PR #123] Check passed: test
[PR #123] All checks passed!
[PR #123] Enabling auto-merge...
[PR #123] Waiting for merge...
[PR #123] Successfully merged!
```

## Gotchas

1. **Required reviews block auto-merge**
   - Babysitter can't approve PRs
   - Get reviews before starting babysitter

2. **Branch protection rules**
   - Some repos require linear history (no merge commits)
   - Some repos block force pushes
   - Check repo settings first

3. **Rate limits**
   - GitHub API has rate limits
   - Poll interval should be 60+ seconds

4. **Flaky detection isn't perfect**
   - Real failures might be retried
   - Max retries prevents infinite loops

5. **Merge conflicts during babysitting**
   - If main branch is very active, conflicts may recur
   - Consider merging during low-activity periods

6. **Auto-merge requires repo settings**
   - Auto-merge must be enabled in repo settings
   - Not all repos allow it

## Integration with Other Skills

- `/commit` - Create the initial PR
- `/careful` - Use when babysitting production PRs
- `/deploy-railway` - After merge, trigger deployment

## Example Session

```
User: Babysit PR #42

Claude: Starting babysitter for PR #42...

[Checking PR status]
- Title: "Add user authentication"
- State: OPEN
- Mergeable: MERGEABLE
- Checks: 3 running

[Monitoring checks...]
- lint: passed
- test: running...
- build: running...

[60 seconds later]
- test: failed (timeout)
- Detected flaky pattern: "timeout"
- Retrying check (attempt 1/3)...

[After retry]
- test: passed
- build: passed

[All checks passed]
- Enabling auto-merge (squash)...
- Auto-merge enabled

[Waiting for merge...]
- PR #42 successfully merged!
- Branch deleted

Babysitting complete. PR merged successfully.
```

## Limitations

- Cannot approve PRs (needs human reviewer)
- Cannot resolve complex merge conflicts
- Cannot fix actual test failures
- Limited to 3 retry attempts by default
- 30 minute timeout by default
