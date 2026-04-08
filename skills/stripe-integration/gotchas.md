# Stripe Integration Gotchas

Common mistakes and pitfalls when integrating with Stripe.

---

## API & SDK Issues

### 1. Expand parameter required for nested objects

```python
# BAD - subscription.latest_invoice is just an ID
subscription = stripe.Subscription.retrieve(sub_id)

# GOOD - full invoice object available
subscription = stripe.Subscription.retrieve(
    sub_id,
    expand=['latest_invoice', 'latest_invoice.payment_intent']
)
```

### 2. Amounts are in cents (smallest currency unit)

```python
# BAD - charges $1,000,000
stripe.PaymentIntent.create(amount=1000000, currency='usd')

# GOOD - charges $100.00
stripe.PaymentIntent.create(amount=10000, currency='usd')
```

| Currency | Unit | $10.00 = |
|----------|------|----------|
| USD | cents | 1000 |
| EUR | cents | 1000 |
| JPY | yen | 1000 (no decimals) |
| GBP | pence | 1000 |

### 3. Idempotency keys required for production POST requests

```python
# Always use idempotency keys to prevent duplicate charges
stripe.PaymentIntent.create(
    amount=1000,
    currency='usd',
    idempotency_key=f"order_{order_id}"
)
```

Best practices:
- Use deterministic keys based on business logic (order ID, user ID + action)
- Keys expire after 24 hours
- Same key + same parameters = returns cached result
- Same key + different parameters = returns error

---

## Webhook Gotchas

### 4. Webhook signature MUST be verified before processing

```python
# CRITICAL - Never skip signature verification
try:
    event = stripe.Webhook.construct_event(
        payload, sig_header, endpoint_secret
    )
except stripe.error.SignatureVerificationError:
    return 'Invalid signature', 400  # REJECT immediately
```

### 5. Webhooks can arrive out of order or be duplicated

- Store processed event IDs to handle idempotently
- Check object timestamps, not webhook arrival order
- `invoice.payment_succeeded` may arrive before `checkout.session.completed`

```python
def handle_webhook_idempotently(event_id, handler):
    if is_event_processed(event_id):
        return  # Skip duplicate

    handler()
    mark_event_processed(event_id)
```

### 6. Webhook endpoint must return 200 quickly (< 30 seconds)

- Queue heavy processing for background jobs
- Return 200 immediately, process asynchronously
- Stripe retries failed webhooks for up to 3 days

```python
@app.route('/webhook', methods=['POST'])
def webhook():
    event = verify_and_parse(request)

    # Queue for async processing
    background_queue.enqueue(process_stripe_event, event)

    return 'OK', 200  # Return immediately
```

---

## Subscription Gotchas

### 7. Subscription status lifecycle is complex

```
incomplete -> active -> past_due -> canceled
                     -> unpaid -> canceled
                     -> paused
```

- `incomplete` means first payment failed - user can retry
- `past_due` means renewal failed - send dunning emails
- Always check `status`, not just existence

```python
# BAD
if subscription:
    grant_access()

# GOOD
if subscription and subscription.status == 'active':
    grant_access()
```

### 8. Proration behavior can surprise users

```python
# Disable proration for plan changes if unexpected
stripe.Subscription.modify(
    sub_id,
    items=[{'price': new_price_id}],
    proration_behavior='none'  # or 'create_prorations'
)
```

Options:
- `create_prorations` (default) - Credit for unused time, charge for new
- `none` - No adjustment, new price starts next cycle
- `always_invoice` - Immediately invoice proration

### 9. Trial periods don't trigger invoice.payment_succeeded

- Use `customer.subscription.trial_will_end` (3 days before)
- Use `customer.subscription.updated` when trial ends
- First payment webhook comes when trial ends

---

## Environment & Keys

### 10. Test vs Live mode keys

```python
# Test keys start with sk_test_ and pk_test_
# Live keys start with sk_live_ and pk_live_
# NEVER commit live keys to source control
# NEVER use live keys in development
```

### 11. Webhook secrets are environment-specific

- Each webhook endpoint has its own secret
- Test mode webhooks need test mode secret
- Use `stripe listen --forward-to` for local testing

```bash
# Local development
stripe listen --forward-to localhost:3000/webhook
# Outputs: whsec_... (use this for local testing)
```

---

## Common Errors

### 12. "No such customer" after environment switch

- Customer IDs are mode-specific (test vs live)
- Cannot use test customer in live mode
- Sync customer data between environments manually

### 13. "This PaymentIntent's amount could not be updated"

- Cannot modify amount after confirmation
- Create new PaymentIntent instead
- Cancel old one if needed

### 14. Card declined in test mode

Use specific test cards:
- `4242424242424242` - Success
- `4000000000000002` - Generic decline
- `4000002500003155` - Requires 3D Secure
- `4000000000009995` - Insufficient funds
- `4000000000000069` - Expired card
