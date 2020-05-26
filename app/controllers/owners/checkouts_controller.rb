module Owners
  class CheckoutsController < Owners::ApplicationController
    def create
      render json: checkout_session
    end

    def show
      render json: Stipe::Checkout::Session.retrieve(params[:session_id])
    end

    private

    def checkout_session
      Stripe::Checkout::Session.create(
        mode: 'subscription',
        success_url: "#{ENV['FRONTEND_URL']}/business/profile?success=true",
        cancel_url: "#{ENV['FRONTEND_URL']}/business/profile?success=false",
        payment_method_types: ['card'],
        line_items: [{ price: ENV['STRIPE_SUBSCRIPTION_PRICE_ID'], quantity: 1 }],
        customer_email: current_owner.email,
        client_reference_id: current_owner.id
      )
    end
  end
end
