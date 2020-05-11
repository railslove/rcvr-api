class Company < ApplicationRecord
  include ApiSerializable

  EXPOSED_ATTRIBUTES = %i[id name areas]

  validates :name, presence: true

  belongs_to :owner

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :area
end
