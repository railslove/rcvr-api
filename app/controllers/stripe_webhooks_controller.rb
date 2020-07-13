class StripeWebhooksController < ApplicationController
  def create
    payload = request.body.read
    sig_header = request.headers['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SIGNING_SECRET']

    begin
      Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      return status 400
    rescue Stripe::SignatureVerificationError => e
      return status 400
    end

    if Rails.env.development?
      HandleStripeWebhookJob.perform_now(payload, sig_header)
    else
      HandleStripeWebhookJob.perform_later(payload, sig_header)
    end
  end

  private

  def webhook_params
    params.permit!
  end
end
