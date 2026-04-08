#!/bin/bash
# Railway deployment script for Merka2a backend
# Usage: ./deploy.sh [--skip-tests] [--force]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Config
PRODUCTION_URL="https://pretty-nurturing-production.up.railway.app"
HEALTH_ENDPOINT="${PRODUCTION_URL}/health"

echo -e "${GREEN}=== Railway Deployment Script ===${NC}"

# Parse args
SKIP_TESTS=false
FORCE=false
for arg in "$@"; do
  case $arg in
    --skip-tests) SKIP_TESTS=true ;;
    --force) FORCE=true ;;
  esac
done

# Check Railway CLI
if ! command -v railway &> /dev/null; then
  echo -e "${RED}Error: Railway CLI not installed${NC}"
  echo "Install with: npm install -g @railway/cli"
  exit 1
fi

# Check auth
if ! railway whoami &> /dev/null; then
  echo -e "${RED}Error: Not logged in to Railway${NC}"
  echo "Run: railway login"
  exit 1
fi

# Check branch
BRANCH=$(git branch --show-current)
if [[ "$BRANCH" != "main" && "$FORCE" != "true" ]]; then
  echo -e "${YELLOW}Warning: Not on main branch (current: $BRANCH)${NC}"
  echo "Use --force to deploy anyway"
  exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) && "$FORCE" != "true" ]]; then
  echo -e "${YELLOW}Warning: Uncommitted changes detected${NC}"
  echo "Commit your changes or use --force"
  exit 1
fi

# Run tests
if [[ "$SKIP_TESTS" != "true" ]]; then
  echo -e "${GREEN}Running tests...${NC}"
  npm test || {
    echo -e "${RED}Tests failed. Fix before deploying.${NC}"
    exit 1
  }
fi

# Deploy
echo -e "${GREEN}Deploying to Railway...${NC}"
railway up --detach

# Wait for deployment
echo -e "${GREEN}Waiting for deployment to complete...${NC}"
sleep 30

# Health check
echo -e "${GREEN}Running health check...${NC}"
HEALTH=$(curl -s "$HEALTH_ENDPOINT" || echo '{"status":"error"}')

if echo "$HEALTH" | grep -q '"status":"healthy"'; then
  echo -e "${GREEN}Deployment successful!${NC}"
  echo "$HEALTH" | jq .
else
  echo -e "${RED}Health check failed!${NC}"
  echo "$HEALTH"
  echo ""
  echo "Check logs with: railway logs"
  exit 1
fi

echo -e "${GREEN}=== Deployment Complete ===${NC}"
echo "Production URL: $PRODUCTION_URL"
