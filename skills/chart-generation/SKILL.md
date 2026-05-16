---
name: chart-generation
description: "Auto-invoke AntVis MCP for data visualization and chart creation"
version: 1.0.0
author: globallayer
tags: [charts, visualization, data, analytics, dashboard]
---

# Chart Generation Skill

## Overview

Automatically invokes AntVis Chart MCP when tasks involve:
- Data visualization
- Dashboard creation
- Analytics reporting
- Chart/graph generation

## Auto-Trigger Conditions

This skill activates when the user mentions:
- "chart", "graph", "visualization"
- "dashboard", "analytics"
- "pie chart", "bar chart", "line chart"
- "data visualization", "report"

## AntVis Chart MCP

### Installation (Already Installed)
```bash
npm install -g @antv/mcp-server-chart
```

### Available Chart Types (26+)

| Category | Types |
|----------|-------|
| **Basic** | Area, Bar, Column, Line, Pie, Scatter |
| **Advanced** | Treemap, Sankey, Radar, Heatmap |
| **Statistical** | Box Plot, Histogram, Violin |
| **Hierarchical** | Sunburst, Circle Packing |
| **Network** | Force Graph, Chord |
| **Geographic** | China Maps |
| **Text** | Word Cloud |

### Usage via MCP

When generating charts, use the AntVis MCP server:

```json
{
  "mcpServers": {
    "chart": {
      "command": "npx",
      "args": ["-y", "@antv/mcp-server-chart"]
    }
  }
}
```

## Chart Templates by Project

### Merka2a (B2B Marketplace)
```javascript
// Sales funnel visualization
const funnelData = [
  { stage: 'Visitors', value: 10000 },
  { stage: 'Leads', value: 2500 },
  { stage: 'Qualified', value: 800 },
  { stage: 'Proposals', value: 300 },
  { stage: 'Closed', value: 100 }
];

// Revenue by category
const categoryRevenue = [
  { category: 'Electronics', revenue: 125000 },
  { category: 'Components', revenue: 89000 },
  { category: 'Equipment', revenue: 67000 }
];
```

### Astrobiography (Horoscope App)
```javascript
// User engagement by zodiac sign
const zodiacEngagement = [
  { sign: 'Aries', users: 1200, engagement: 0.85 },
  { sign: 'Taurus', users: 1100, engagement: 0.78 },
  // ... all 12 signs
];

// Daily active users trend
const dauTrend = [
  { date: '2026-05-01', dau: 5200 },
  { date: '2026-05-02', dau: 5400 },
  // ... daily data
];
```

### EverGreen (E-commerce)
```javascript
// Product performance
const productPerformance = [
  { product: 'Indoor Plants', sales: 450, views: 12000 },
  { product: 'Outdoor Plants', sales: 320, views: 8500 },
  { product: 'Accessories', sales: 280, views: 6000 }
];

// Traffic sources
const trafficSources = [
  { source: 'Organic', value: 45 },
  { source: 'Direct', value: 25 },
  { source: 'Social', value: 20 },
  { source: 'Referral', value: 10 }
];
```

## Integration with Supabase

```typescript
// Fetch data from Supabase for charting
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const getChartData = async () => {
  const { data, error } = await supabase
    .from('analytics')
    .select('date, metric, value')
    .gte('date', '2026-01-01')
    .order('date');

  return data;
};
```

## Example Usage

```
User: "Create a dashboard showing Merka2a sales by category"

Claude: [Invokes chart-generation skill]
1. Queries sales data from Supabase
2. Uses AntVis MCP to generate:
   - Pie chart for category distribution
   - Line chart for trend over time
   - Bar chart for top products
3. Returns embeddable chart components
```
