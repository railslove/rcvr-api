class StripeWebhooksController < ApplicationController
  def create
    # TODO Move this to interactor
    case event.type
    when 'checkout.session.completed'
      owner = Owner.find(event_data.client_reference_id)

      owner.block_at = nil

      if event_data.mode == 'subscription'
        # A new subscription was created
        owner.stripe_customer_id = event_data.customer
        owner.stripe_subscription_id = event_data.subscription
      else
        # We just collected a new billing method and need to update the customer with that
        Stripe::Customer.update(owner.stripe_customer_id, invoice_settings: { default_payment_method: setup_intent.payment_method })
      end

      owner.save!
    when 'customer.subscription.updated'
      owner = Owner.find_by(stripe_subscription_id: event_data.id)

      if event_data.cancel_at.present?
        owner.update(block_at: Time.at(event_data.cancel_at))
      else
        owner.update(block_at: nil)
      end
    end
  end

  private

  def setup_intent
    Stripe::SetupIntent.retrieve(event_data.setup_intent)
  end

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
