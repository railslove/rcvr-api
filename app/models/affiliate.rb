class Affiliate < ApplicationRecord
  include RailsAdminConfig::ForAffiliate

  has_one_attached :logo

  attr_accessor :remove_logo
  after_save { logo.purge if remove_logo == '1' }

  validates :logo, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  validates :code, presence: true

  def link
    URI("#{ENV['FRONTEND_URL']}/business/setup/intro").tap do |uri|
      uri.query = { affiliate: code }.to_param if code?
    end.to_s
  end
end
