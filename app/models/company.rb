class Company < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForCompany
  include Rails.application.routes.url_helpers

  EXPOSED_ATTRIBUTES = %i[id name menu_link areas menu_pdf_link]

  validates :name, presence: true

  belongs_to :owner, touch: true

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :areas, dependent: :destroy
  has_many :data_requests, dependent: :destroy

  has_one_attached :menu_pdf

  scope :not_free, -> { where.not(is_free: true) }

  delegate :menu_alias, :frontend_url, :public_key, to: :owner

  def menu_pdf_link
    return unless menu_pdf.attached?

    url_for(menu_pdf)
  end

  def stats_url
    owners_company_stats_url(self)
  end

  def open_ticket_count
    tickets.open.count
  end

  def ticket_count
    tickets.count
  end
end
