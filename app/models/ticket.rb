class Ticket < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForTicket
  
  AUTO_CHECKOUT_AFTER = 4.hours
  EXPOSED_ATTRIBUTES = %i[id entered_at left_at area_id company_name area_name]

  belongs_to :area
  has_one :company, through: :area

  validates :id, write_once_only: true
  validates :entered_at, write_once_only: true
  validates :left_at, write_once_only: true
  validates :encrypted_data, write_once_only: true
  validates :public_key, write_once_only: true
  validates :area_id, write_once_only: true

  enum status: { neutral: 0, at_risk: 2 }

  scope :open, -> { where(left_at: nil) }

  def schedule_auto_checkout_job
    AutoCheckoutTicketJob.set(wait: AUTO_CHECKOUT_AFTER).perform_later(id)
  end

  def self.overlapping_time(time_range)
    Ticket.where('entered_at <= ? AND (left_at >= ? OR left_at IS NULL)',
                 time_range.end, time_range.begin)
  end

  def self.mark_cases!(time_range, area_id)
    Ticket.transaction do
      Ticket
        .overlapping_time(time_range)
        .where(area_id: area_id)
        .find_each { |ticket| ticket.update(status: :at_risk) }
    end
  end

  def company_name
    company.name
  end

  def area_name
    area.name
  end
end
