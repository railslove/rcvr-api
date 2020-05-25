class DataRequest < ApplicationRecord
  include RailsAdminConfig::ForDataRequest

  belongs_to :company
  has_many :tickets, -> (request) { during(request.time_range) }, through: :company

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
