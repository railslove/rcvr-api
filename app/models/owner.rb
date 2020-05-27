class Owner < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForOwner

  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         :confirmable, jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true

  has_many :companies, dependent: :destroy
  has_many :areas, through: :companies
  has_many :data_requests, through: :companies

  EXPOSED_ATTRIBUTES = %i[id email name public_key affiliate stripe_subscription_status]

  def update_stripe_subscription_status!
    update!(stripe_subscription_status: Stripe::Subscription.retrieve(stripe_subscription_id).status)
  end
end
