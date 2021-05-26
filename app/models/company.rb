class Company < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForCompany
  include Rails.application.routes.url_helpers

  enum location_type: [
    :other,
    :retail, 
    :food_service, 
    :craft, 
    :workplace, 
    :educational_institution, 
    :public_building
  ], _prefix: 'location'

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
    location_type
    cwa_link_enabled
    cwa_crypto_seed
  ]

  validates :name, presence: true
  validates_inclusion_of :location_type, in: location_types.keys, if: Proc.new { |company| company.cwa_link_enabled }

  belongs_to :owner, touch: true

  has_many :areas, dependent: :destroy
  has_many :tickets, through: :areas, dependent: :destroy
  has_many :data_requests, dependent: :destroy

  has_one_attached :menu_pdf

  scope :not_free, -> { where.not(is_free: true) }
  scope :unknown_affiliate_and_zip, ->() { 
    joins(:owner).where("coalesce(companies.zip, '') = '' and coalesce(owners.affiliate, '') = ''")
  }

  delegate :menu_alias, :frontend_url, :public_key, to: :owner
  delegate :affiliate_logo, to: :owner
  delegate :auto_checkout_time, to: :owner
  delegate :affiliate, to: :owner, allow_nil: true

  attr_accessor :remove_menu_pdf

  before_update {
    menu_pdf.purge if remove_menu_pdf == '1' and menu_pdf.attached?
  }

  def menu_pdf_link
    return unless menu_pdf.attached?

    url_for(menu_pdf)
  end

  def stats_url
    if self.id
      owners_company_stats_url(self)
    end
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

  def affiliate=(code) 
    self.owner.update(affiliate: code)
  end

end
