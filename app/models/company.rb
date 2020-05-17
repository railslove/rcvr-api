class Company < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForCompany

  EXPOSED_ATTRIBUTES = %i[id name menu_link areas]

  validates :name, presence: true

  belongs_to :owner

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :areas
end
