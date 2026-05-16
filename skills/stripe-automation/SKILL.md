---
name: stripe-automation
description: "Auto-invoke Stripe Agent Toolkit for payment-related tasks"
version: 1.0.0
author: globallayer
tags: [payments, stripe, billing, subscriptions, e-commerce]
---

# Stripe Automation Skill

## Overview

Automatically invokes Stripe Agent Toolkit when tasks involve payments, billing, or subscriptions.

## Auto-Trigger Conditions

Activates when user mentions: "payment", "checkout", "billing", "stripe", "subscription", "invoice"

## Stripe Agent Toolkit (Installed)

```bash
npm list -g @stripe/agent-toolkit
# @stripe/agent-toolkit@0.9.0
```

## Usage

```typescript
import { StripeAgentToolkit } from '@stripe/agent-toolkit/ai-sdk';

const toolkit = new StripeAgentToolkit({
  secretKey: process.env.STRIPE_SECRET_KEY,
  configuration: {
    actions: {
      paymentLinks: { create: true },
      customers: { create: true, read: true },
      subscriptions: { create: true, update: true }
    }
  }
});
```

## Merka2a Integration

```typescript
// B2B subscription tiers
const PLANS = {
  starter: { priceId: 'price_starter', listings: 10 },
  professional: { priceId: 'price_pro', listings: 100 },
  enterprise: { priceId: 'price_enterprise', listings: -1 }
};
```
