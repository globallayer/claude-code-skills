"""
Example: Stripe Webhook Handler
===============================

Production-ready webhook handler with signature verification,
idempotency, and async processing.
"""

import stripe
import os
from flask import Flask, request, jsonify
import hashlib
import json

app = Flask(__name__)

stripe.api_key = os.environ.get("STRIPE_SECRET_KEY")
WEBHOOK_SECRET = os.environ.get("STRIPE_WEBHOOK_SECRET")

# In production, use Redis or database
processed_events = set()


def is_event_processed(event_id: str) -> bool:
    """Check if event was already processed (idempotency)."""
    return event_id in processed_events


def mark_event_processed(event_id: str):
    """Mark event as processed."""
    processed_events.add(event_id)


@app.route('/webhook', methods=['POST'])
def webhook():
    payload = request.data
    sig_header = request.headers.get('Stripe-Signature')

    # CRITICAL: Always verify webhook signature
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, WEBHOOK_SECRET
        )
    except ValueError as e:
        return jsonify({'error': 'Invalid payload'}), 400
    except stripe.error.SignatureVerificationError as e:
        return jsonify({'error': 'Invalid signature'}), 400

    # Idempotency check
    if is_event_processed(event['id']):
        return jsonify({'status': 'already_processed'}), 200

    # Route to appropriate handler
    event_type = event['type']
    data = event['data']['object']

    try:
        if event_type == 'payment_intent.succeeded':
            handle_payment_succeeded(data)
        elif event_type == 'payment_intent.payment_failed':
            handle_payment_failed(data)
        elif event_type == 'customer.subscription.created':
            handle_subscription_created(data)
        elif event_type == 'customer.subscription.updated':
            handle_subscription_updated(data)
        elif event_type == 'customer.subscription.deleted':
            handle_subscription_deleted(data)
        elif event_type == 'invoice.payment_succeeded':
            handle_invoice_paid(data)
        elif event_type == 'invoice.payment_failed':
            handle_invoice_failed(data)
        elif event_type == 'checkout.session.completed':
            handle_checkout_completed(data)
        else:
            print(f"Unhandled event type: {event_type}")

        mark_event_processed(event['id'])

    except Exception as e:
        # Log error but return 200 to prevent Stripe retries
        # if the error is non-recoverable
        print(f"Error processing {event_type}: {e}")
        # For recoverable errors, return 500 to trigger retry
        # return jsonify({'error': str(e)}), 500

    return jsonify({'status': 'success'}), 200


def handle_payment_succeeded(payment_intent):
    """Process successful one-time payment."""
    customer_id = payment_intent.get('customer')
    amount = payment_intent['amount']
    metadata = payment_intent.get('metadata', {})

    print(f"Payment succeeded: {payment_intent['id']}")
    print(f"  Amount: ${amount/100:.2f}")
    print(f"  Customer: {customer_id}")
    print(f"  Metadata: {metadata}")

    # TODO: Fulfill order, send confirmation email


def handle_payment_failed(payment_intent):
    """Handle failed payment."""
    error = payment_intent.get('last_payment_error', {})
    print(f"Payment failed: {error.get('message')}")

    # TODO: Notify customer, update order status


def handle_subscription_created(subscription):
    """Handle new subscription."""
    customer_id = subscription['customer']
    status = subscription['status']

    print(f"Subscription created: {subscription['id']}")
    print(f"  Status: {status}")

    # TODO: Provision access if status is 'active'


def handle_subscription_updated(subscription):
    """Handle subscription changes."""
    status = subscription['status']
    print(f"Subscription updated: {subscription['id']} -> {status}")

    # Check for important status changes
    if status == 'past_due':
        # TODO: Send dunning email
        pass
    elif status == 'canceled':
        # TODO: Revoke access
        pass


def handle_subscription_deleted(subscription):
    """Handle subscription cancellation."""
    customer_id = subscription['customer']
    print(f"Subscription deleted for customer: {customer_id}")

    # TODO: Revoke access, send cancellation email


def handle_invoice_paid(invoice):
    """Handle successful subscription renewal."""
    subscription_id = invoice.get('subscription')
    print(f"Invoice paid for subscription: {subscription_id}")

    # TODO: Extend access period


def handle_invoice_failed(invoice):
    """Handle failed subscription renewal."""
    subscription_id = invoice.get('subscription')
    attempt_count = invoice.get('attempt_count', 0)

    print(f"Invoice failed for subscription: {subscription_id}")
    print(f"  Attempt: {attempt_count}")

    # TODO: Send payment failure notification


def handle_checkout_completed(session):
    """Handle completed checkout session."""
    customer_email = session.get('customer_email')
    mode = session.get('mode')

    print(f"Checkout completed: {session['id']}")
    print(f"  Mode: {mode}")
    print(f"  Email: {customer_email}")

    if mode == 'subscription':
        subscription_id = session.get('subscription')
        # TODO: Link subscription to user
    else:
        payment_intent_id = session.get('payment_intent')
        # TODO: Fulfill one-time purchase


if __name__ == '__main__':
    app.run(port=3000, debug=True)
