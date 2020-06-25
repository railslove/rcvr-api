module Owners
  class SubscriptionSettingsController < Owners::ApplicationController
    before_action :authenticate_owner!

    def create
      render json: session
    end

    private

    def session
      Stripe::BillingPortal::Session.create({
        customer: current_owner.stripe_customer_id,
        return_url: "#{current_owner.frontend_url}/business/profile",
      })
    end
  end
end
