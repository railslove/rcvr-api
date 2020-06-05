class HandleStripeWebhookJob < ApplicationJob
  def perform(params, body, stripe_signature)
    event = Stripe::Webhook.construct_event(body, stripe_signature, ENV['STRIPE_WEBHOOK_SIGNING_SECRET'])

    StripeWebhookHandler.call(event: event)
  end
end
