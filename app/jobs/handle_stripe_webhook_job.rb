class HandleStripeWebhookJob < ApplicationJob
  def perform(body, stripe_signature)
    # We already check the request in the controller, to make sure that jobs that previously
    # failed or are in the queue for long are still handled correctly we set the tolerance this high
    event = Stripe::Webhook.construct_event(body, stripe_signature, ENV['STRIPE_WEBHOOK_SIGNING_SECRET'], tolerance: 1.month.seconds.to_i)

    StripeWebhookHandler.call(event: event)
  end
end
