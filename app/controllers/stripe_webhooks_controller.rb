class StripeWebhooksController < ApplicationController
  def create
    byebug

    puts 1
  end

  private

  def event
    Stripe::Webhook.construct_event(
      request.body.read,
      request.headers['HTTP_STRIPE_SIGNATURE'],
      ENV['STRIPE_WEBHOOK_SIGNING_SECRET']
    )
  end
end
