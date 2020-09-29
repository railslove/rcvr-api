class Whitelabel < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForWhitelabel

  has_many :frontends
  has_many :owners
  has_one_attached :logo
end
