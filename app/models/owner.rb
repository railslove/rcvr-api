class Owner < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForOwner

  EXPOSED_ATTRIBUTES = %i[id email name phone company_name public_key affiliate stripe_subscription_status
                          can_use_for_free trial_ends_at frontend_url block_at menu_alias sepa_trial]

  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         :confirmable, :recoverable, jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true

  scope :affiliate, -> { where.not(affiliate: [nil, '']).order(affiliate: :asc) }
  scope :with_stripe_data, -> { where.not(stripe_subscription_id: nil) }

  belongs_to :frontend

  has_many :companies, dependent: :destroy
  has_many :areas, through: :companies
  has_many :data_requests, through: :companies

  after_commit :update_stripe_subscription

  attr_accessor :dont_call_stripe

  def block_at
    return nil if can_use_for_free

    super
  end

  def care_user?
    frontend&.url == 'https://care.rcvr.app'
  end

  def blocked?
    block_at&.past?
  end

  def frontend_url
    # This could be replaced by a delegate once the migration has been done on production

    frontend&.url || ENV['FRONTEND_URL']
  end

  def stripe_subscription_status
    stripe_subscription&.status
  rescue Stripe::InvalidRequestError
    nil
  end

  def active_stripe_subscription?
    stripe_subscription_id? && stripe_subscription_status != 'canceled'
  end

  def stripe_price_id
    main_price_id = ENV['STRIPE_SUBSCRIPTION_PRICE_ID']

    raise "ENV['STRIPE_SUBSCRIPTION_PRICE_ID'] is empty" unless main_price_id.present?

    Affiliate.find_by(code: affiliate)&.stripe_price_id_monthly || main_price_id
  end

  def stripe_subscription
    return OpenStruct.new unless stripe_subscription_id?

    Stripe::Subscription.retrieve(stripe_subscription_id)
  end

  def update_stripe_subscription
    return unless active_stripe_subscription?
    return if @dont_call_stripe
    Stripe::Subscription.update(stripe_subscription_id, quantity: companies.not_free.count)
  end

  def cancel_stripe_subscription!
    return unless active_stripe_subscription?

    Stripe::Subscription.delete(stripe_subscription_id)

    update(stripe_subscription_id: nil)
  end

  def auto_checkout_time
    auto_checkout_minutes&.minutes || ::Ticket::AUTO_CHECKOUT_AFTER
  end

  def trial_end
    # There is not trial if the trial is blank or has already been passed, else it has to be at least two days in the future
    trial_ends_at? && trial_ends_at.future? ? [trial_ends_at, 50.hours.from_now].max.to_i : nil
  end
end
