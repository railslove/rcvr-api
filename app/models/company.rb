class Company < ApplicationRecord
  validates :name, presence: true

  belongs_to :owner

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :area

  private

  def attributes
    super.merge(areas: areas)
  end

  def company_name
    areas
  end
end
