---
name: deploy-railway
description: Use when deploying to Railway, checking deployment status, viewing Railway logs, or troubleshooting Railway deployments. Specifically for Merka2a backend at pretty-nurturing-production.up.railway.app. Trigger on "deploy", "railway", "push to production", or "check deployment".
risk: medium
source: local
---

# Railway Deployment Skill

Deploys and manages the Merka2a backend on Railway.

## Live Infrastructure

| Service | URL |
|---------|-----|
| Production API | `https://pretty-nurturing-production.up.railway.app` |
| Railway Dashboard | `https://railway.app/dashboard` |

## Prerequisites

1. **Railway CLI installed**: `npm install -g @railway/cli`
2. **Authenticated**: `railway login`
3. **Project linked**: Run `railway link` in project directory

## Deployment Workflow

### Standard Deploy (from main branch)

```bash
# 1. Verify on correct branch
git branch --show-current

# 2. Ensure all changes committed
git status

# 3. Push to trigger auto-deploy (if configured)
git push origin main

# 4. Or manual deploy
railway up
```

### Deploy with Verification

```bash
# 1. Deploy
railway up --detach

# 2. Check deployment status
railway status

# 3. View logs
railway logs --tail

# 4. Health check
curl -s https://pretty-nurturing-production.up.railway.app/health | jq .
```

## Commands Reference

| Command | Purpose |
|---------|---------|
| `railway up` | Deploy current directory |
| `railway up --detach` | Deploy without waiting |
| `railway status` | Check deployment status |
| `railway logs` | View application logs |
| `railway logs --tail` | Stream live logs |
| `railway variables` | List environment variables |
| `railway variables set KEY=value` | Set env variable |
| `railway open` | Open Railway dashboard |
| `railway connect` | Connect to database shell |

## Environment Variables

Required variables (set via Railway dashboard or CLI):

```bash
# Database
DATABASE_URL=postgresql://...

# Supabase
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...

# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Auth
JWT_SECRET=...
SESSION_SECRET=...

# App
NODE_ENV=production
PORT=3000
```

## Health Check Endpoint

The API exposes `/health` for monitoring:

```bash
curl https://pretty-nurturing-production.up.railway.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2026-04-08T...",
  "version": "1.0.0"
}
```

## Rollback Procedure

If deployment fails:

```bash
# 1. View recent deployments
railway deployments

# 2. Rollback to previous
railway rollback

# 3. Or redeploy specific commit
git checkout <commit-hash>
railway up
```

## Gotchas

1. **Build timeout** - Railway has 20-minute build limit. If exceeded, optimize build or use Docker.

2. **Memory limits** - Free tier has 512MB RAM. Monitor with `railway logs` for OOM errors.

3. **Sleep mode** - Free tier services sleep after 30 min inactivity. First request may be slow.

4. **Environment sync** - After changing env vars, redeploy is required:
   ```bash
   railway variables set KEY=value
   railway up  # Redeploy to pick up changes
   ```

5. **Database connection pooling** - Use connection pooler URL for Supabase:
   ```
   # Use pooler (port 6543), not direct (port 5432)
   DATABASE_URL=postgres://...pooler.supabase.com:6543/postgres
   ```

6. **Prisma on Railway** - Add to package.json scripts:
   ```json
   "postinstall": "prisma generate"
   ```

7. **Port binding** - Railway sets PORT automatically. Don't hardcode:
   ```typescript
   const port = process.env.PORT || 3000;
   ```

8. **Logs persistence** - Railway logs are ephemeral. For persistent logging, use external service (Datadog, Logtail).

## Troubleshooting

### Deploy stuck or failing

```bash
# Check build logs
railway logs --build

# Check runtime logs
railway logs

# Verify environment
railway variables
```

### Database connection issues

```bash
# Test connection
railway connect

# Check DATABASE_URL format
railway variables | grep DATABASE
```

### Service not responding

```bash
# Check if service is running
railway status

# Check for crashes in logs
railway logs | grep -i "error\|crash\|exit"

# Verify health endpoint
curl -v https://pretty-nurturing-production.up.railway.app/health
```

## Pre-Deploy Checklist

Before deploying:

- [ ] All tests passing locally
- [ ] No console.log statements (use proper logger)
- [ ] Environment variables documented
- [ ] Database migrations applied
- [ ] No hardcoded secrets
- [ ] Health endpoint working

## Post-Deploy Verification

After deploying:

```bash
# 1. Check health
curl https://pretty-nurturing-production.up.railway.app/health

# 2. Test critical endpoints
curl https://pretty-nurturing-production.up.railway.app/api/v1/status

# 3. Monitor logs for errors (2 minutes)
railway logs --tail
```

## Integration with CI/CD

For automated deploys, add to GitHub Actions:

```yaml
- name: Deploy to Railway
  uses: bervProject/railway-deploy@main
  with:
    railway_token: ${{ secrets.RAILWAY_TOKEN }}
    service: merka2a-backend
```

## Related Skills

- `commit` - For committing before deploy
- `security-review` - Run before production deploys
- `database-migrations` - For schema changes
