class Owner < ApplicationRecord
  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         jwt_revocation_strategy: JwtBlacklist

  validates :email, uniqueness: true, presence: true
end
