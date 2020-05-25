class Area < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForArea

  EXPOSED_ATTRIBUTES = %i[id name menu_link company_id company_name]

  belongs_to :company
  has_many :tickets

  delegate :menu_link, to: :company
  delegate :id, to: :company, prefix: :company
  delegate :name, to: :company, prefix: :company
end
