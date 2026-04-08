/**
 * Example: Server/Client Component Split Pattern
 * ==============================================
 *
 * Shows how to properly split server and client components
 * for optimal performance and functionality.
 */

// ==========================================
// SERVER COMPONENT (default - no directive)
// ==========================================
// app/posts/page.tsx

import { db } from '@/lib/db';
import { PostList } from './PostList';
import { SearchFilter } from './SearchFilter';

// This component runs on the server
// - Can directly access database
// - Can use async/await
// - Cannot use hooks or event handlers
export default async function PostsPage() {
  // Direct database access (server-only)
  const posts = await db.post.findMany({
    orderBy: { createdAt: 'desc' },
    take: 20,
  });

  return (
    <div>
      <h1>Posts</h1>

      {/* Client component for interactivity */}
      <SearchFilter />

      {/* Pass server data to client component */}
      <PostList initialPosts={posts} />
    </div>
  );
}

// ==========================================
// CLIENT COMPONENT (interactive)
// ==========================================
// app/posts/SearchFilter.tsx

'use client';

import { useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';

// This component runs in the browser
// - Can use hooks (useState, useEffect)
// - Can handle events (onClick, onChange)
// - Cannot directly access database
export function SearchFilter() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [query, setQuery] = useState(searchParams.get('q') ?? '');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    router.push(`/posts?q=${encodeURIComponent(query)}`);
  };

  return (
    <form onSubmit={handleSearch}>
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search posts..."
      />
      <button type="submit">Search</button>
    </form>
  );
}

// ==========================================
// HYBRID: Server parent + Client child
// ==========================================
// app/posts/PostList.tsx

'use client';

import { useState } from 'react';
import type { Post } from '@/types';

interface PostListProps {
  initialPosts: Post[];  // Data passed from server
}

export function PostList({ initialPosts }: PostListProps) {
  const [posts, setPosts] = useState(initialPosts);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  return (
    <ul>
      {posts.map((post) => (
        <li key={post.id}>
          <h2>{post.title}</h2>
          <button onClick={() => setExpandedId(
            expandedId === post.id ? null : post.id
          )}>
            {expandedId === post.id ? 'Collapse' : 'Expand'}
          </button>
          {expandedId === post.id && <p>{post.content}</p>}
        </li>
      ))}
    </ul>
  );
}

// ==========================================
// PATTERN: Server component as children
// ==========================================
// This allows server components inside client components

// app/dashboard/layout.tsx (server)
import { DashboardShell } from './DashboardShell';
import { Sidebar } from './Sidebar';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <DashboardShell>
      {/* Sidebar is a server component passed as child */}
      <Sidebar />
      {children}
    </DashboardShell>
  );
}

// app/dashboard/DashboardShell.tsx (client)
'use client';

import { useState } from 'react';

export function DashboardShell({ children }: { children: React.ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(true);

  return (
    <div className={sidebarOpen ? 'sidebar-open' : 'sidebar-closed'}>
      <button onClick={() => setSidebarOpen(!sidebarOpen)}>
        Toggle Sidebar
      </button>
      {/* Server components rendered as children */}
      {children}
    </div>
  );
}

// app/dashboard/Sidebar.tsx (server - can fetch data)
import { db } from '@/lib/db';

export async function Sidebar() {
  const navItems = await db.navItem.findMany();

  return (
    <nav>
      {navItems.map((item) => (
        <a key={item.id} href={item.href}>{item.label}</a>
      ))}
    </nav>
  );
}
