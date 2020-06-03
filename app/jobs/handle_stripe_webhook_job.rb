class HandleStripeWebhookJob < ApplicationJob
  def perform(params)
    StripeWebhookHandler.call(event_from(params))
  end

  private

  def event_from(params)
    @event ||= Stripe::Webhook.construct_event(
      request.body.read,
      request.headers['HTTP_STRIPE_SIGNATURE'],
      ENV['STRIPE_WEBHOOK_SIGNING_SECRET']
    )
  end
end
