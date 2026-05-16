---
name: competitor-analysis
description: "Auto-invoke web scraping tools for market research and competitor analysis"
version: 1.0.0
author: globallayer
tags: [scraping, research, competitors, market-analysis, seo]
---

# Competitor Analysis Skill

## Overview

Automatically invokes web scraping and research tools when tasks involve:
- Competitor website analysis
- Market research
- Price monitoring
- Content gap analysis
- SEO competitor research

## Auto-Trigger Conditions

This skill activates when the user mentions:
- "competitor", "competition", "market research"
- "analyze website", "scrape", "extract data"
- "price comparison", "pricing analysis"
- "content gap", "keyword gap"
- "market analysis", "industry research"

## Available Tools

### 1. Crawlee (Python)
```python
from crawlee import PlaywrightCrawler, Request

async def scrape_competitor(url: str):
    crawler = PlaywrightCrawler()

    @crawler.router.default_handler
    async def request_handler(context):
        page = context.page

        # Extract key data
        title = await page.title()
        meta_desc = await page.locator('meta[name="description"]').get_attribute('content')
        h1s = await page.locator('h1').all_text_contents()
        products = await page.locator('.product-card').count()

        return {
            'url': url,
            'title': title,
            'meta_description': meta_desc,
            'headings': h1s,
            'product_count': products
        }

    await crawler.run([Request(url=url)])
```

### 2. Firecrawl (Claude Plugin)
Already enabled. Use for:
- Deep website crawling
- Structured data extraction
- Interactive page automation

### 3. Exa Search (MCP)
Web search for research and discovery.

## Analysis Templates

### Competitor Website Audit
```python
AUDIT_CHECKLIST = {
    'seo': [
        'title_tag',
        'meta_description',
        'h1_structure',
        'internal_links',
        'schema_markup',
        'page_speed'
    ],
    'content': [
        'blog_frequency',
        'content_length',
        'topic_coverage',
        'media_usage'
    ],
    'ux': [
        'navigation_depth',
        'cta_placement',
        'mobile_friendly',
        'load_time'
    ],
    'business': [
        'pricing_model',
        'product_count',
        'feature_list',
        'testimonials'
    ]
}
```

### Price Monitoring
```python
async def monitor_prices(competitors: list[str], product_selector: str):
    results = []

    for url in competitors:
        crawler = PlaywrightCrawler()

        @crawler.router.default_handler
        async def handler(context):
            prices = await context.page.locator(product_selector).all_text_contents()
            results.append({
                'competitor': url,
                'prices': prices,
                'timestamp': datetime.now().isoformat()
            })

        await crawler.run([Request(url=url)])

    return results
```

## Project-Specific Competitors

### Merka2a (B2B Electronics)
| Competitor | Focus | URL Pattern |
|------------|-------|-------------|
| Alibaba | General B2B | alibaba.com |
| ThomasNet | Industrial | thomasnet.com |
| GlobalSources | Electronics | globalsources.com |
| Made-in-China | Manufacturing | made-in-china.com |

### EverGreen (Plants E-commerce)
| Competitor | Focus | URL Pattern |
|------------|-------|-------------|
| The Sill | Indoor plants | thesill.com |
| Bloomscape | Delivery | bloomscape.com |
| Plants.com | General | plants.com |

### Astrobiography (Horoscope Apps)
| Competitor | Focus | Platform |
|------------|-------|----------|
| Co-Star | AI astrology | iOS/Android |
| The Pattern | Personality | iOS/Android |
| Sanctuary | Daily readings | iOS/Android |

## Workflow: Full Competitor Analysis

```
1. DISCOVERY
   - Identify top 5-10 competitors
   - Map their digital presence

2. TECHNICAL AUDIT
   - Crawl sites with Crawlee
   - Extract SEO signals
   - Analyze page structure

3. CONTENT ANALYSIS
   - Map topic coverage
   - Identify content gaps
   - Analyze publishing frequency

4. BUSINESS INTELLIGENCE
   - Extract pricing
   - Count products/features
   - Analyze positioning

5. REPORTING
   - Use AntVis for visualizations
   - Generate comparison tables
   - Identify opportunities
```

## Example Usage

```
User: "Analyze Merka2a's top 3 competitors"

Claude: [Invokes competitor-analysis skill]
1. Uses Firecrawl to crawl competitor sites
2. Extracts SEO signals, pricing, features
3. Uses Crawlee for deeper data extraction
4. Generates comparison report with AntVis charts
5. Identifies gaps and opportunities
```

## Output Format

```markdown
## Competitor Analysis Report

### Summary
| Metric | Competitor A | Competitor B | Merka2a |
|--------|-------------|-------------|---------|
| Products | 10,000 | 5,000 | 500 |
| Blog posts/mo | 8 | 4 | 2 |
| Domain Rating | 65 | 45 | 20 |

### Opportunities
1. [Gap identified]
2. [Feature to add]
3. [Content to create]

### Recommended Actions
- [ ] Action 1
- [ ] Action 2
```
