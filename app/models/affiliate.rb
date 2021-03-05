class Affiliate < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForAffiliate
  include Rails.application.routes.url_helpers

  EXPOSED_ATTRIBUTES = %i[name logo_download_link]

  has_one_attached :logo

  validates :logo, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  validates :code, presence: true
  validates :custom_trial_phase, duration: true

  def logo_download_link
    return unless logo.attached?

    url_for(logo)
  end

  def link
    URI("#{ENV['FRONTEND_URL']}/business/setup/intro").tap do |uri|
      uri.query = { affiliate: code }.to_param if code?
    end.to_s
  end
end
