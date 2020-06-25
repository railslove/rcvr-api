class Owner < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForOwner

  EXPOSED_ATTRIBUTES = %i[id email name public_key affiliate stripe_subscription_status
                          can_use_for_free trial_ends_at block_at frontend_url]

  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         :confirmable, jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true

  scope :affiliate, -> { where.not(affiliate: nil) }

  has_many :companies, dependent: :destroy
  has_many :areas, through: :companies
  has_many :data_requests, through: :companies

  delegate :status, to: :stripe_subscription, prefix: :stripe_subscription

  after_commit :update_stripe_subscription

  def frontend_url
    super || ENV['FRONTEND_URL']
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

    Stripe::Subscription.update(stripe_subscription_id, quantity: companies.count)
  end

  def cancel_stripe_subscription!
    return unless active_stripe_subscription?

    Stripe::Subscription.delete(stripe_subscription_id)

    update(stripe_subscription_id: nil)
  end
end
