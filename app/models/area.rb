class Area < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForArea

  belongs_to :company

  has_many :tickets

  EXPOSED_ATTRIBUTES = %i[id name]
end
