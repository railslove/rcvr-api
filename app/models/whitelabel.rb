class Whitelabel < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForWhitelabel

  has_one_attached :logo
end
