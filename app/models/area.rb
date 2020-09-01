class Area < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForArea

  EXPOSED_ATTRIBUTES = %i[id name menu_link company_id company_name owner_is_blocked menu_alias]

  belongs_to :company
  has_many :tickets, dependent: :destroy

  delegate :id, to: :company, prefix: :company
  delegate :name, to: :company, prefix: :company
  delegate :menu_alias, to: :company

  def owner_is_blocked
    company.owner.blocked?
  end

  def menu_link
    company.menu_pdf_link || company.menu_link
  end
end
