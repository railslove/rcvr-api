class StripeWebhooksController < ApplicationController
  def create
    case event.type
    when 'checkout.session.completed'
      owner = Owner.find(event_data.client_reference_id)

      owner.update(stripe_customer_id: event_data.customer, stripe_subscription_id: event_data.subscription)
      owner.update_stripe_subscription_status!
    end
  end

  private

  def event_data
    event.data.object
  end

  def event
    @event ||= Stripe::Webhook.construct_event(
      request.body.read,
      request.headers['HTTP_STRIPE_SIGNATURE'],
      ENV['STRIPE_WEBHOOK_SIGNING_SECRET']
    )
  end
end
