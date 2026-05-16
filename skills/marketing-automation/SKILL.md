---
name: marketing-automation
description: "Auto-invoke marketing tools for social media, content, and SEO tasks"
version: 1.0.0
author: globallayer
tags: [marketing, seo, social-media, content, automation]
---

# Marketing Automation Skill

## Overview

Automatically invokes free marketing tools when tasks involve:
- Social media posting/scheduling
- Content creation and distribution
- SEO analysis and optimization
- Competitor research
- Email campaigns

## Auto-Trigger Conditions

This skill activates when the user mentions:
- "post to social media", "schedule post", "social content"
- "SEO", "keywords", "search ranking", "optimize content"
- "competitor analysis", "market research"
- "email campaign", "newsletter"
- "marketing", "promotion", "brand awareness"

## Available Tools

### 1. Crawlee (Web Scraping)
```bash
# Python library for competitor analysis
from crawlee import PlaywrightCrawler
```
**Use for:** Competitor website analysis, price monitoring, content scraping

### 2. AntVis Chart MCP
```bash
npx @antv/mcp-server-chart
```
**Use for:** Marketing dashboards, analytics visualization

### 3. Firecrawl (Plugin)
Already enabled as Claude plugin for web scraping and research.

### 4. Context7 (Plugin)
Already enabled for documentation lookup.

## Workflow: Social Media Content

When user asks for social media content:

1. **Research Phase**
   - Use Firecrawl to analyze trending content in niche
   - Use Context7 for best practices

2. **Creation Phase**
   - Generate platform-optimized content
   - Create variations for different platforms

3. **Scheduling Recommendation**
   - Recommend Postiz (self-hosted) for scheduling
   - Provide API integration code if needed

## Workflow: SEO Analysis

When user asks for SEO help:

1. **Technical Audit**
   - Use Crawlee for site crawling
   - Check meta tags, headings, internal links

2. **Content Optimization**
   - Analyze keyword density
   - Check AEO (Answer Engine Optimization) readiness
   - Verify FAQ schema opportunities

3. **Reporting**
   - Use AntVis Chart MCP for visualizations

## Self-Hosted Tool Recommendations

| Tool | Purpose | Install |
|------|---------|---------|
| **Postiz** | Social scheduling | `docker pull postiz/postiz` |
| **Listmonk** | Email marketing | `docker pull listmonk/listmonk` |
| **Activepieces** | Workflow automation | `docker pull activepieces/activepieces` |

## Integration Code Templates

### Postiz API Integration
```typescript
// POST to Postiz for scheduling
const schedulePost = async (content: string, platforms: string[]) => {
  const response = await fetch('http://localhost:5000/public/v1/posts', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.POSTIZ_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      content,
      platforms,
      scheduledAt: new Date(Date.now() + 3600000).toISOString()
    })
  });
  return response.json();
};
```

### Listmonk Email Campaign
```typescript
// Trigger email via Listmonk API
const sendCampaign = async (listId: number, subject: string, body: string) => {
  const response = await fetch('http://localhost:9000/api/campaigns', {
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa('admin:password'),
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      name: subject,
      subject,
      lists: [listId],
      type: 'regular',
      content_type: 'richtext',
      body
    })
  });
  return response.json();
};
```

## AEO (Answer Engine Optimization) Checklist

For AI search visibility:
- [ ] Direct answers in first paragraph
- [ ] FAQ schema markup implemented
- [ ] "What is [topic]?" pages created
- [ ] Entity consistency across site
- [ ] Structured data for products/services

## Example Usage

```
User: "Help me create social media content for Merka2a launch"

Claude: [Invokes marketing-automation skill]
1. Uses Firecrawl to research B2B marketplace launches
2. Generates platform-specific content
3. Provides Postiz integration code for scheduling
4. Creates visual assets recommendations
```
