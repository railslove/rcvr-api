class Company < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForCompany
  include Rails.application.routes.url_helpers

  LOCATION_TYPES = %w{
    RETAIL
    FOOD_SERVICE
    CRAFT
    WORKPLACE
    EDUCATIONAL_INSTITUTION
    PUBLIC_BUILDING
  }

  EXPOSED_ATTRIBUTES = %i[
    id
    name
    street
    zip
    city
    menu_link 
    areas
    menu_pdf_link
    privacy_policy_link
    need_to_show_corona_test
  ]

  validates :name, presence: true
  validates_inclusion_of :location_type, in: LOCATION_TYPES, allow_nil: true

  belongs_to :owner, touch: true

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :areas, dependent: :destroy
  has_many :data_requests, dependent: :destroy

  has_one_attached :menu_pdf

  scope :not_free, -> { where.not(is_free: true) }

  delegate :menu_alias, :frontend_url, :public_key, to: :owner
  delegate :affiliate_logo, to: :owner

  attr_accessor :remove_menu_pdf

  before_update {
    menu_pdf.purge if remove_menu_pdf == '1' and menu_pdf.attached?
  }

  before_save :assign_cwa_crypto_if_needed
  
  def assign_cwa_crypto_if_needed
    if self.cwa_crypto_seed.nil?
      self.cwa_crypto_seed = SecureRandom.random_bytes(16)
    end
  end

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

  def address
    "#{street}, #{zip} #{city}"
  end
end
