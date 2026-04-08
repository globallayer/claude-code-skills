# Supabase Automation Gotchas

Common mistakes and pitfalls when working with Supabase.

---

## Connection & Authentication

### 1. Connection pooler vs direct connection

```
# Use pooler (port 6543) for serverless/edge functions
postgres://...pooler.supabase.com:6543/postgres

# Use direct (port 5432) for migrations and long-running connections
postgres://...supabase.com:5432/postgres
```

- Pooler has connection limits and shorter timeouts
- Direct connection required for `ALTER TABLE`, migrations
- Use `?pgbouncer=true` for pooler mode in connection string

### 2. Service role key vs anon key

| Key | Access | Use Case |
|-----|--------|----------|
| `anon` | Subject to RLS | Client-side, browser |
| `service_role` | Bypasses RLS | Server-side ONLY |

**NEVER expose `service_role` key to client/browser**

### 3. RLS policies block queries silently

```sql
-- Query returns empty, not error, when RLS blocks access
SELECT * FROM private_table;  -- Returns [] not 403
```

- Enable RLS: `ALTER TABLE x ENABLE ROW LEVEL SECURITY;`
- Check policies: `SELECT * FROM pg_policies;`
- New tables have RLS disabled by default

---

## SQL Execution

### 4. Array syntax is PostgreSQL, not JSON

```sql
-- BAD (JSON array - will fail)
INSERT INTO tags VALUES ('["a", "b"]');

-- GOOD (PostgreSQL array)
INSERT INTO tags VALUES (ARRAY['a', 'b']);
INSERT INTO tags VALUES ('{"a", "b"}');
```

### 5. Case-sensitive identifiers must be quoted

```sql
-- BAD - looks for lowercase "mytable"
SELECT * FROM MyTable;

-- GOOD - preserves case
SELECT * FROM "MyTable";
```

### 6. 60-second timeout on SQL execution

- Break large migrations into smaller statements
- Use `read_only: true` for SELECT to prevent accidental writes
- Complex JOINs on large tables may timeout

---

## Data Types

### 7. UUID generation

```sql
-- Enable extension first
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Then use in default
id UUID DEFAULT uuid_generate_v4()

-- Or use gen_random_uuid() (built-in since Postgres 13)
id UUID DEFAULT gen_random_uuid()
```

### 8. Timestamps are UTC by default

```sql
-- Supabase stores as timestamptz (with timezone)
created_at TIMESTAMPTZ DEFAULT NOW()

-- Client receives ISO 8601 string, convert locally
```

### 9. JSONB vs JSON

| Type | Indexing | Query Speed | Use Case |
|------|----------|-------------|----------|
| `JSONB` | Yes | Faster | Queryable JSON |
| `JSON` | No | Slower | Exact preservation |

Always prefer `JSONB` unless you need exact formatting.

---

## Real-time & Edge

### 10. Real-time requires explicit enable

```sql
-- Enable realtime for a table
ALTER PUBLICATION supabase_realtime ADD TABLE my_table;

-- Or via dashboard: Table Editor -> Enable Realtime
```

### 11. Edge functions have 150ms CPU limit (free tier)

- Use background tasks for heavy processing
- Optimize cold starts with minimal imports
- Pro tier: 50ms-400ms depending on plan

### 12. Storage RLS is separate from database RLS

- Storage policies defined in dashboard, not SQL
- Bucket must be public OR have policies
- Use `storage.objects` for policies:
  ```sql
  CREATE POLICY "Users can view own files"
  ON storage.objects FOR SELECT
  USING (auth.uid() = owner);
  ```

---

## Common Errors

### 13. "relation does not exist" (42P01)

- Check schema prefix: `public.users` vs `auth.users`
- Check case sensitivity (see #5)
- Verify table was created (migrations ran)

### 14. "permission denied for table"

- RLS blocking access (check policies)
- Using wrong key (anon vs service_role)
- Grant missing: `GRANT SELECT ON table TO anon;`

### 15. "duplicate key value violates unique constraint"

```sql
-- Use upsert with ON CONFLICT:
INSERT INTO x VALUES (...)
ON CONFLICT (id) DO UPDATE SET ...

-- Or ignore duplicates:
INSERT INTO x VALUES (...)
ON CONFLICT DO NOTHING
```
