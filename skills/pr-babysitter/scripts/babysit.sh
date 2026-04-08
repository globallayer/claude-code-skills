#!/bin/bash
# PR Babysitter Script
# Usage: ./babysit.sh <PR_NUMBER> [--max-retries N] [--timeout M]

set -e

PR_NUMBER=$1
MAX_RETRIES=${2:-3}
TIMEOUT_MINUTES=${3:-30}
POLL_INTERVAL=60
RETRY_COUNT=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
  echo -e "${BLUE}[PR #${PR_NUMBER}]${NC} $1"
}

success() {
  echo -e "${GREEN}[PR #${PR_NUMBER}]${NC} $1"
}

warn() {
  echo -e "${YELLOW}[PR #${PR_NUMBER}]${NC} $1"
}

error() {
  echo -e "${RED}[PR #${PR_NUMBER}]${NC} $1"
}

# Check if PR exists
if ! gh pr view "$PR_NUMBER" &>/dev/null; then
  error "PR #$PR_NUMBER not found"
  exit 1
fi

log "Starting babysitter..."
log "Max retries: $MAX_RETRIES"
log "Timeout: $TIMEOUT_MINUTES minutes"

START_TIME=$(date +%s)
END_TIME=$((START_TIME + TIMEOUT_MINUTES * 60))

while true; do
  CURRENT_TIME=$(date +%s)
  if [ "$CURRENT_TIME" -gt "$END_TIME" ]; then
    error "Timeout exceeded ($TIMEOUT_MINUTES minutes)"
    exit 1
  fi

  # Get PR status
  PR_JSON=$(gh pr view "$PR_NUMBER" --json state,mergeable,statusCheckRollup,autoMergeRequest)
  STATE=$(echo "$PR_JSON" | jq -r '.state')
  MERGEABLE=$(echo "$PR_JSON" | jq -r '.mergeable')

  # Check if merged
  if [ "$STATE" == "MERGED" ]; then
    success "PR successfully merged!"
    exit 0
  fi

  # Check if closed
  if [ "$STATE" == "CLOSED" ]; then
    error "PR was closed"
    exit 1
  fi

  # Check for merge conflicts
  if [ "$MERGEABLE" == "CONFLICTING" ]; then
    warn "Merge conflict detected"
    log "Attempting to resolve..."

    # Try to update branch
    if gh pr update-branch "$PR_NUMBER" 2>/dev/null; then
      log "Branch updated, waiting for checks..."
    else
      error "Could not resolve merge conflict automatically"
      error "Manual resolution required"
      exit 1
    fi
  fi

  # Get check status
  CHECKS_JSON=$(gh pr checks "$PR_NUMBER" --json name,state,conclusion 2>/dev/null || echo "[]")

  RUNNING=$(echo "$CHECKS_JSON" | jq '[.[] | select(.state == "pending" or .state == "in_progress")] | length')
  FAILED=$(echo "$CHECKS_JSON" | jq '[.[] | select(.conclusion == "failure")] | length')
  PASSED=$(echo "$CHECKS_JSON" | jq '[.[] | select(.conclusion == "success")] | length')
  TOTAL=$(echo "$CHECKS_JSON" | jq 'length')

  log "Checks: $PASSED passed, $RUNNING running, $FAILED failed (of $TOTAL)"

  # Handle failures
  if [ "$FAILED" -gt 0 ]; then
    FAILED_CHECKS=$(echo "$CHECKS_JSON" | jq -r '.[] | select(.conclusion == "failure") | .name')

    if [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; then
      warn "Retrying failed checks (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)"

      # Get the failed run ID and retry
      RUN_ID=$(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')
      if gh run rerun "$RUN_ID" --failed 2>/dev/null; then
        log "Retry triggered"
        RETRY_COUNT=$((RETRY_COUNT + 1))
      else
        warn "Could not trigger retry"
      fi
    else
      error "Max retries exceeded"
      error "Failed checks: $FAILED_CHECKS"
      exit 1
    fi
  fi

  # All checks passed?
  if [ "$FAILED" -eq 0 ] && [ "$RUNNING" -eq 0 ] && [ "$TOTAL" -gt 0 ]; then
    success "All checks passed!"

    # Check if auto-merge already enabled
    AUTO_MERGE=$(echo "$PR_JSON" | jq -r '.autoMergeRequest')
    if [ "$AUTO_MERGE" == "null" ]; then
      log "Enabling auto-merge..."
      if gh pr merge "$PR_NUMBER" --auto --squash; then
        success "Auto-merge enabled"
      else
        warn "Could not enable auto-merge (may need reviews)"
      fi
    else
      log "Auto-merge already enabled, waiting..."
    fi
  fi

  log "Waiting $POLL_INTERVAL seconds..."
  sleep "$POLL_INTERVAL"
done
