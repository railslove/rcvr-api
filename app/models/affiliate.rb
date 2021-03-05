class Affiliate < ApplicationRecord
  include RailsAdminConfig::ForAffiliate

  has_one_attached :logo

  validates :logo, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  validates :code, presence: true
  validates :custom_trial_phase, duration: true

  def link
    URI("#{ENV['FRONTEND_URL']}/business/setup/intro").tap do |uri|
      uri.query = { affiliate: code }.to_param if code?
    end.to_s
  end
end
