class Company < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :owner

  has_many :tickets, dependent: :destroy
  has_many :areas, dependent: :destroy

  private

  def attributes
    super.merge(areas: areas)
  end

  def company_name
    areas
  end
end
