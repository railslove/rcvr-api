class StripeWebhookHandler
  include Interactor
  include RequiredAttributes

  required_attributes %i[event]

  delegate :owner, to: :context

  before :set_owner
  after :save_owner

  def call
    handler_method = "handle_#{event.type.gsub('.', '_')}"

    return unless respond_to?(handler_method)

    public_send(handler_method)
  end

  def handle_checkout_session_completed
    owner.block_at = nil

    owner.stripe_customer_id = event_data.customer if event_data.customer
    owner.stripe_subscription_id = event_data.subscription if event_data.subscription

    Stripe::Customer.update(
      owner.stripe_customer_id,
      invoice_settings: { default_payment_method: payment_method },
      address: payment_method.billing_details.address.to_h
    )
  end

  def handle_customer_subscription_created
    owner.block_at = nil

    owner.stripe_customer_id = event_data.customer
    owner.stripe_subscription_id = event_data.id
  end

  def handle_customer_subscription_updated
    owner.block_at = event_data.cancel_at&.yield_self(&Time.method(:at))
  end

  private

  def payment_method
    payment_method_id = event_data.mode == 'subscription' ?
      Stripe::Subscription.retrieve(event_data.subscription).default_payment_method :
      Stripe::SetupIntent.retrieve(event_data.setup_intent).payment_method

    Stripe::PaymentMethod.retrieve(payment_method_id)
  end

  def set_owner
    case event.type
    when 'checkout.session.completed'
      context.owner = Owner.find(event_data.client_reference_id)
    when 'customer.subscription.updated'
      context.owner = Owner.find_by!(stripe_subscription_id: event_data.id)
    when 'customer.subscription.created'
      context.owner = Owner.find_by!(stripe_customer_id: event_data.customer)
    end
  end

  def save_owner
    owner&.save!
  end

  def event_data
    event.data.object
  end
end
