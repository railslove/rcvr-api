class Owner < ApplicationRecord
  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true

  has_many :companies, dependent: :destroy
  has_many :areas, through: :companies
end
