class StripeWebhooksController < ApplicationController
  def create
    HandleStripeWebhookJob.perform_now(params)
  end
end
