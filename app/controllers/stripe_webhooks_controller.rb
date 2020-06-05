class StripeWebhooksController < ApplicationController
  def create
    if Rails.env.development?
      HandleStripeWebhookJob.perform_now(webhook_params, request.body.read, request.headers['HTTP_STRIPE_SIGNATURE'])
    else
      HandleStripeWebhookJob.perform_later(webhook_params, request.body.read, request.headers['HTTP_STRIPE_SIGNATURE'])
    end
  end

  private

  def webhook_params
    params.permit!
  end
end
