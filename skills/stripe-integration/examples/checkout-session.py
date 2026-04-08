"""
Example: Create a Stripe Checkout Session
==========================================

This example shows how to create both one-time payment
and subscription checkout sessions.
"""

import stripe
import os

stripe.api_key = os.environ.get("STRIPE_SECRET_KEY")


def create_one_time_checkout(
    amount_cents: int,
    product_name: str,
    success_url: str,
    cancel_url: str,
    customer_email: str = None,
    metadata: dict = None
):
    """
    Create a one-time payment checkout session.

    Args:
        amount_cents: Amount in cents (e.g., 2000 = $20.00)
        product_name: Name shown to customer
        success_url: Redirect after successful payment
        cancel_url: Redirect if customer cancels
        customer_email: Pre-fill email field
        metadata: Custom data to attach to the session

    Returns:
        Checkout session with URL to redirect customer
    """
    session = stripe.checkout.Session.create(
        payment_method_types=['card'],
        line_items=[{
            'price_data': {
                'currency': 'usd',
                'product_data': {
                    'name': product_name,
                },
                'unit_amount': amount_cents,
            },
            'quantity': 1,
        }],
        mode='payment',
        success_url=success_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url=cancel_url,
        customer_email=customer_email,
        metadata=metadata or {},
    )
    return session


def create_subscription_checkout(
    price_id: str,
    success_url: str,
    cancel_url: str,
    customer_email: str = None,
    trial_days: int = None
):
    """
    Create a subscription checkout session.

    Args:
        price_id: Stripe Price ID (starts with 'price_')
        success_url: Redirect after successful subscription
        cancel_url: Redirect if customer cancels
        customer_email: Pre-fill email field
        trial_days: Optional trial period

    Returns:
        Checkout session with URL to redirect customer
    """
    session_params = {
        'payment_method_types': ['card'],
        'line_items': [{
            'price': price_id,
            'quantity': 1,
        }],
        'mode': 'subscription',
        'success_url': success_url + '?session_id={CHECKOUT_SESSION_ID}',
        'cancel_url': cancel_url,
    }

    if customer_email:
        session_params['customer_email'] = customer_email

    if trial_days:
        session_params['subscription_data'] = {
            'trial_period_days': trial_days
        }

    session = stripe.checkout.Session.create(**session_params)
    return session


# Usage example
if __name__ == '__main__':
    # One-time payment
    session = create_one_time_checkout(
        amount_cents=2000,  # $20.00
        product_name='Premium Feature',
        success_url='https://example.com/success',
        cancel_url='https://example.com/cancel',
        metadata={'order_id': 'order_123'}
    )
    print(f"Checkout URL: {session.url}")

    # Subscription
    sub_session = create_subscription_checkout(
        price_id='price_1234567890',
        success_url='https://example.com/welcome',
        cancel_url='https://example.com/pricing',
        trial_days=14
    )
    print(f"Subscription URL: {sub_session.url}")
