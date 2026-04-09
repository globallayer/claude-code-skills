---
name: nextjs-best-practices
description: "Next.js App Router principles. Server Components, data fetching, routing patterns."
risk: unknown
source: community
date_added: "2026-02-27"
---

# Next.js Best Practices

> Principles for Next.js App Router development.

---

## 1. Server vs Client Components

### Decision Tree

```
Does it need...?
│
├── useState, useEffect, event handlers
│   └── Client Component ('use client')
│
├── Direct data fetching, no interactivity
│   └── Server Component (default)
│
└── Both? 
    └── Split: Server parent + Client child
```

### By Default

| Type | Use |
|------|-----|
| **Server** | Data fetching, layout, static content |
| **Client** | Forms, buttons, interactive UI |

---

## 2. Data Fetching Patterns

### Fetch Strategy

| Pattern | Use |
|---------|-----|
| **Default** | Static (cached at build) |
| **Revalidate** | ISR (time-based refresh) |
| **No-store** | Dynamic (every request) |

### Data Flow

| Source | Pattern |
|--------|---------|
| Database | Server Component fetch |
| API | fetch with caching |
| User input | Client state + server action |

---

## 3. Routing Principles

### File Conventions

| File | Purpose |
|------|---------|
| `page.tsx` | Route UI |
| `layout.tsx` | Shared layout |
| `loading.tsx` | Loading state |
| `error.tsx` | Error boundary |
| `not-found.tsx` | 404 page |

### Route Organization

| Pattern | Use |
|---------|-----|
| Route groups `(name)` | Organize without URL |
| Parallel routes `@slot` | Multiple same-level pages |
| Intercepting `(.)` | Modal overlays |

---

## 4. API Routes

### Route Handlers

| Method | Use |
|--------|-----|
| GET | Read data |
| POST | Create data |
| PUT/PATCH | Update data |
| DELETE | Remove data |

### Best Practices

- Validate input with Zod
- Return proper status codes
- Handle errors gracefully
- Use Edge runtime when possible

---

## 5. Performance Principles

### Image Optimization

- Use next/image component
- Set priority for above-fold
- Provide blur placeholder
- Use responsive sizes

### Bundle Optimization

- Dynamic imports for heavy components
- Route-based code splitting (automatic)
- Analyze with bundle analyzer

---

## 6. Metadata

### Static vs Dynamic

| Type | Use |
|------|-----|
| Static export | Fixed metadata |
| generateMetadata | Dynamic per-route |

### Essential Tags

- title (50-60 chars)
- description (150-160 chars)
- Open Graph images
- Canonical URL

---

## 7. Caching Strategy

### Cache Layers

| Layer | Control |
|-------|---------|
| Request | fetch options |
| Data | revalidate/tags |
| Full route | route config |

### Revalidation

| Method | Use |
|--------|-----|
| Time-based | `revalidate: 60` |
| On-demand | `revalidatePath/Tag` |
| No cache | `no-store` |

---

## 8. Server Actions

### Use Cases

- Form submissions
- Data mutations
- Revalidation triggers

### Best Practices

- Mark with 'use server'
- Validate all inputs
- Return typed responses
- Handle errors

---

## 9. Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| 'use client' everywhere | Server by default |
| Fetch in client components | Fetch in server |
| Skip loading states | Use loading.tsx |
| Ignore error boundaries | Use error.tsx |
| Large client bundles | Dynamic imports |

---

## 10. Project Structure

```
app/
├── (marketing)/     # Route group
│   └── page.tsx
├── (dashboard)/
│   ├── layout.tsx   # Dashboard layout
│   └── page.tsx
├── api/
│   └── [resource]/
│       └── route.ts
└── components/
    └── ui/
```

---

> **Remember:** Server Components are the default for a reason. Start there, add client only when needed.

## Gotchas

### Server vs Client Components

1. **'use client' is contagious upward, not downward**
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

2. **Cannot import server-only code in client components**
   ```tsx
   // BAD - will error at build time
   'use client'
   import { db } from '@/lib/db';  // Server-only!

   // GOOD - fetch in server, pass as props
   // page.tsx (server)
   const data = await db.query();
   <ClientComponent data={data} />
   ```

3. **useState/useEffect only work in client components**
   - If you need state, add 'use client'
   - Consider: can this be server-side instead?

### Data Fetching

4. **fetch() in Server Components is auto-deduped**
   ```tsx
   // These two fetches only make ONE request
   // ComponentA.tsx
   const data = await fetch('/api/data');
   // ComponentB.tsx
   const data = await fetch('/api/data');  // Deduped!
   ```

5. **Dynamic rendering triggered unexpectedly**
   ```tsx
   // These force dynamic rendering (no static generation):
   cookies()
   headers()
   searchParams
   fetch(..., { cache: 'no-store' })

   // Check with: export const dynamic = 'error'
   ```

6. **Revalidation doesn't work in development**
   - `revalidate: 60` only works in production build
   - Use `next build && next start` to test caching

### Routing

7. **layout.tsx doesn't re-render on navigation**
   ```tsx
   // BAD - layout won't update when URL changes
   // layout.tsx
   const pathname = usePathname();  // Won't trigger re-render

   // GOOD - use in a client component child
   ```

8. **loading.tsx only shows on first load**
   - Subsequent navigations use client-side transition
   - Use Suspense boundaries for granular loading states

9. **error.tsx must be client component**
   ```tsx
   'use client'  // REQUIRED
   export default function Error({ error, reset }) { ... }
   ```

### Server Actions

10. **Server Actions need 'use server' at top**
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

11. **Server Actions can't return non-serializable data**
    ```tsx
    // BAD - Date object not serializable
    return { createdAt: new Date() }

    // GOOD - serialize first
    return { createdAt: new Date().toISOString() }
    ```

### Build & Performance

12. **Large page data causes hydration mismatch**
    - Keep props passed to client components small
    - Fetch data client-side for large datasets

13. **next/image requires width/height or fill**
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

14. **Middleware runs on EVERY request**
    - Keep middleware fast and lightweight
    - Use matcher config to limit routes:
    ```ts
    export const config = {
      matcher: ['/dashboard/:path*']
    }
    ```

### Common Errors

15. **"Text content did not match"**
    - Server/client rendered different content
    - Common cause: dates, random values, browser-only APIs
    - Fix: useEffect for browser-only code, or suppressHydrationWarning

16. **"Functions cannot be passed directly to Client Components"**
    - Can't pass functions as props from server to client
    - Use Server Actions instead

17. **"Dynamic server usage" in static export**
    - Using cookies/headers in static page
    - Add `export const dynamic = 'force-dynamic'`

## When to Use
This skill is applicable to execute the workflow or actions described in the overview.
