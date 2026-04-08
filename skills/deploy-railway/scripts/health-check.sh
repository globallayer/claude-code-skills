#!/bin/bash
# Quick health check for Railway deployment
# Usage: ./health-check.sh [--verbose]

PRODUCTION_URL="https://pretty-nurturing-production.up.railway.app"
HEALTH_ENDPOINT="${PRODUCTION_URL}/health"

VERBOSE=false
[[ "$1" == "--verbose" ]] && VERBOSE=true

echo "Checking: $HEALTH_ENDPOINT"

RESPONSE=$(curl -s -w "\n%{http_code}" "$HEALTH_ENDPOINT")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" == "200" ]]; then
  echo "Status: HEALTHY"
  if [[ "$VERBOSE" == "true" ]]; then
    echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
  fi
  exit 0
else
  echo "Status: UNHEALTHY (HTTP $HTTP_CODE)"
  echo "$BODY"
  exit 1
fi
