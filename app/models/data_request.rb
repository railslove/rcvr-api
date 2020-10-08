class DataRequest < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForDataRequest

  EXPOSED_ATTRIBUTES = %i[id from to accepted_at]

  belongs_to :company
  has_many :tickets, -> (request) { during(request.time_range) }, through: :company

  validates :from, presence: true
  validates :to, presence: true
  validates :reason, presence: true

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
