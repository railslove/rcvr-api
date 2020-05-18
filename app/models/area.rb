class Area < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForArea

  EXPOSED_ATTRIBUTES = %i[id name menu_link]

  belongs_to :company
  has_many :tickets

  delegate :menu_link, to: :company
end
