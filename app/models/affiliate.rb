class Affiliate < ApplicationRecord
  include RailsAdminConfig::ForAffiliate

  validates :code, presence: true
  validates :custom_trial_phase, duration: true

  def link
    URI("#{ENV['FRONTEND_URL']}/business/setup/intro").tap do |uri|
      uri.query = { affiliate: code }.to_param if code?
    end.to_s
  end
end
