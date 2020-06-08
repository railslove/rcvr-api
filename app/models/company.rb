class Company < ApplicationRecord
  include ApiSerializable
  include Rails.application.routes.url_helpers

  EXPOSED_ATTRIBUTES = %i[id name menu_link areas menu_pdf_link]

  validates :name, presence: true

  belongs_to :owner, touch: true

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :areas
  has_many :data_requests, dependent: :destroy

  has_one_attached :menu_pdf

  def menu_pdf_link
    return unless menu_pdf.attached?

    url_for(menu_pdf)
  end
end
