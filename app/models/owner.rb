class Owner < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForOwner

  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         :confirmable, jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true

  has_many :companies, dependent: :destroy
  has_many :areas, through: :companies

  EXPOSED_ATTRIBUTES = %i[id email name]
end
