class Whitelabel < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForWhitelabel

  has_many :frontends, dependent: :nullify
  has_many :owners, dependent: :nullify
  has_one_attached :logo
end
