class Owner < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForOwner

  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         :confirmable, jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true

  has_many :companies, dependent: :destroy
  has_many :areas, through: :companies
  has_many :data_requests, through: :companies

  EXPOSED_ATTRIBUTES = %i[id email name public_key affiliate stripe_subscription_status can_use_for_free trial_ends_at]

  delegate :status, to: :stripe_subscription, prefix: :stripe_subscription

  def stripe_subscription
    return OpenStruct.new unless stripe_subscription_id?

    @stripe_subscription ||= Stripe::Subscription.retrieve(stripe_subscription_id)
  end
end
