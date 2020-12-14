module Owners
  class CheckoutsController < Owners::ApplicationController
    before_action :authenticate_owner!

    def create
      render json: checkout_session
    end

    def setup_intent
      render json: { id: client_secret }
    end

    def owner_payment_method
      Stripe::Customer.update(
        create_or_retrieve_customer,
        {
          invoice_settings: {
            default_payment_method: params[:token]
          }
        }
      )
      render json: create_sepa_subscription
    end

    private

    def create_or_retrieve_customer
      return current_owner.stripe_customer_id if current_owner.stripe_customer_id.present?

      customer = Stripe::Customer.create({ email: current_owner.email })
      current_owner.update(stripe_customer_id: customer.id)
      customer.id
    end

    def checkout_session
      Stripe::Checkout::Session.create(checkout_session_params)
    end

    def client_secret
      intent = Stripe::SetupIntent.create({ payment_method_types: ['sepa_debit'],
                                            customer: create_or_retrieve_customer })
      intent['client_secret']
    end

    def create_sepa_subscription
      subscription = Stripe::Subscription.create({
        customer: create_or_retrieve_customer,
        items: [{ price: current_owner.stripe_price_id, quantity: current_owner.companies.count }],
        trial_end: current_owner.trial_end,
        default_tax_rates: [ENV['STRIPE_TAX_RATE_ID']],
        expand: ['latest_invoice.payment_intent']
      })
      current_owner.update(stripe_subscription_id: subscription.id)
      # not sure if we are leaking something we shouldn't be leaking when returning subscription
      # better return nil
      nil
    end

    def checkout_session_params
      params = {
        success_url: "#{current_owner.frontend_url}/business/profile?success=true",
        cancel_url: "#{current_owner.frontend_url}/business/profile?success=false",
        payment_method_types: ['card'],
        billing_address_collection: 'required',
        client_reference_id: current_owner.id,
      }

      if current_owner.active_stripe_subscription?
        params.merge(params_for_existing_subscription)
      else
        params.merge(params_for_new_subscription)
      end
    end

    def params_for_new_subscription
      {
        mode: 'subscription',
        customer_email: current_owner.email,
        line_items: [{ price: current_owner.stripe_price_id, quantity: current_owner.companies.count }],
        subscription_data: {
          trial_end: current_owner.trial_end,
          default_tax_rates: [ENV['STRIPE_TAX_RATE_ID']]
        }
      }
    end

    def params_for_existing_subscription
      {
        mode: 'setup',
        customer: current_owner.stripe_customer_id,
        setup_intent_data: {
          metadata: {
            subscription_id: current_owner.stripe_subscription_id
          }
        }
      }
    end
  end
end
