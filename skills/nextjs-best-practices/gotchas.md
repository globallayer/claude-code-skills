# Next.js Best Practices Gotchas

Common mistakes and pitfalls when building with Next.js App Router.

---

## Server vs Client Components

### 1. 'use client' is contagious upward, not downward

```tsx
// ClientComponent.tsx - 'use client'
// ServerComponent.tsx - no directive (server by default)

// BAD - ServerComponent becomes client component
// ClientComponent.tsx
import ServerComponent from './ServerComponent';

// GOOD - Pass server component as children
// page.tsx (server)
<ClientComponent>
  <ServerComponent />
</ClientComponent>
```

### 2. Cannot import server-only code in client components

```tsx
// BAD - will error at build time
'use client'
import { db } from '@/lib/db';  // Server-only!

// GOOD - fetch in server, pass as props
// page.tsx (server)
const data = await db.query();
<ClientComponent data={data} />
```

### 3. useState/useEffect only work in client components

- If you need state, add 'use client'
- Consider: can this be server-side instead?
- Server components cannot use hooks

---

## Data Fetching

### 4. fetch() in Server Components is auto-deduped

```tsx
// These two fetches only make ONE request
// ComponentA.tsx
const data = await fetch('/api/data');
// ComponentB.tsx
const data = await fetch('/api/data');  // Deduped!
```

### 5. Dynamic rendering triggered unexpectedly

```tsx
// These force dynamic rendering (no static generation):
cookies()
headers()
searchParams
fetch(..., { cache: 'no-store' })

// Check with: export const dynamic = 'error'
```

### 6. Revalidation doesn't work in development

- `revalidate: 60` only works in production build
- Use `next build && next start` to test caching
- Development mode always fetches fresh data

---

## Routing

### 7. layout.tsx doesn't re-render on navigation

```tsx
// BAD - layout won't update when URL changes
// layout.tsx
const pathname = usePathname();  // Won't trigger re-render

// GOOD - use in a client component child
```

### 8. loading.tsx only shows on first load

- Subsequent navigations use client-side transition
- Use Suspense boundaries for granular loading states
- Consider skeleton UI in loading.tsx

### 9. error.tsx must be client component

```tsx
'use client'  // REQUIRED
export default function Error({ error, reset }) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  );
}
```

---

## Server Actions

### 10. Server Actions need 'use server' at top

```tsx
// In separate file
'use server'
export async function submitForm() { ... }

// Or inline in server component
async function Page() {
  async function submit() {
    'use server'
    // action code
  }
}
```

### 11. Server Actions can't return non-serializable data

```tsx
// BAD - Date object not serializable
return { createdAt: new Date() }

// GOOD - serialize first
return { createdAt: new Date().toISOString() }

// BAD - functions not serializable
return { onClick: () => {} }
```

---

## Build & Performance

### 12. Large page data causes hydration mismatch

- Keep props passed to client components small
- Fetch data client-side for large datasets
- Use pagination for large lists

### 13. next/image requires width/height or fill

```tsx
// BAD - will error
<Image src="/photo.jpg" alt="Photo" />

// GOOD - explicit dimensions
<Image src="/photo.jpg" alt="Photo" width={800} height={600} />

// GOOD - fill parent container
<div className="relative w-full h-64">
  <Image src="/photo.jpg" alt="Photo" fill />
</div>
```

### 14. Middleware runs on EVERY request

- Keep middleware fast and lightweight
- Use matcher config to limit routes:

```ts
export const config = {
  matcher: ['/dashboard/:path*', '/api/:path*']
}
```

---

## Common Errors

### 15. "Text content did not match"

- Server/client rendered different content
- Common cause: dates, random values, browser-only APIs
- Fix: useEffect for browser-only code, or suppressHydrationWarning

```tsx
// BAD
<p>{new Date().toLocaleString()}</p>

// GOOD
const [date, setDate] = useState<string>()
useEffect(() => setDate(new Date().toLocaleString()), [])
```

### 16. "Functions cannot be passed directly to Client Components"

- Can't pass functions as props from server to client
- Use Server Actions instead

```tsx
// BAD
<ClientComponent onClick={handleClick} />

// GOOD - use server action
<form action={serverAction}>
  <button type="submit">Submit</button>
</form>
```

### 17. "Dynamic server usage" in static export

- Using cookies/headers in static page
- Add `export const dynamic = 'force-dynamic'`
- Or remove the dynamic function usage
