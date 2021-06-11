class Area < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForArea

  EXPOSED_ATTRIBUTES = %i[id name menu_link checkin_link company_id company_name company_need_to_show_corona_test company_cwa_link_enabled affiliate_logo owner_is_blocked menu_alias frontend_url public_key privacy_policy_link test_exception].freeze

  belongs_to :company
  has_many :tickets, dependent: :destroy

  delegate :id, :name, :need_to_show_corona_test, :cwa_link_enabled, to: :company, prefix: :company
  delegate :menu_alias, :frontend_url, :public_key, :privacy_policy_link, to: :company
  delegate :affiliate_logo, to: :company

  def owner_is_blocked
    company.owner.blocked?
  end

  def menu_link
    company.menu_pdf_link || company.menu_link
  end

  def checkin_link
    URI("#{company.owner.frontend_url}/checkin").tap do |uri|
      uri.query = {
        a: id,
        k: company.owner.public_key
      }.to_param
    end
  end
end
