class DataRequest < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForDataRequest

  EXPOSED_ATTRIBUTES = %i[id from to reason accepted_at iris_data_authorization_token proxy_endpoint iris_client_name]

  belongs_to :company
  has_many :tickets, -> (request) { during(request.time_range) }, through: :company

  scope :unaccepted, -> { where(accepted_at: nil) }

  validates :from, presence: true
  validates :to, presence: true

  def accepted?
    accepted_at?
  end

  def time_range
    from..to
  end

  def accept!
    transaction do
      update(accepted_at: Time.zone.now) unless accepted?

      tickets.each { |ticket| ticket.update(status: :at_risk) }
    end
  end
end
