class StripeWebhooksController < ApplicationController
  def create
    if Rails.env.development?
      HandleStripeWebhookJob.perform_now(params, request.body.read, request.headers['HTTP_STRIPE_SIGNATURE'])
    else
      HandleStripeWebhookJob.perform_later(params, request.body.read, request.headers['HTTP_STRIPE_SIGNATURE'])
    end
  end
end
