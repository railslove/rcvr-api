class Ticket < ApplicationRecord
  include ApiSerializable
  include RailsAdminConfig::ForTicket

  has_paper_trail on: [:update], only: [:encrypted_data]

  AUTO_CHECKOUT_AFTER = 4.hours
  EXPOSED_ATTRIBUTES = %i[id entered_at left_at area_id company_name area_name]

  enum status: { neutral: 0, at_risk: 2 }

  belongs_to :area
  has_one :company, through: :area

  validates :id, write_once_only: true
  validates :entered_at, write_once_only: true
  validates :left_at, write_once_only: true
  validates :public_key, write_once_only: true
  validates :area_id, write_once_only: true

  scope :open, -> { where(left_at: nil) }
  scope :by_company, -> (company_id) { joins(area: :company).where(areas: { company_id: company_id }) }
  scope :during, -> (range) { where('entered_at <= ? AND (left_at >= ? OR left_at IS NULL)', range.end, range.begin) }

  delegate :name, to: :company, prefix: :company
  delegate :name, to: :area, prefix: :area

  def schedule_auto_checkout_job
    AutoCheckoutTicketJob.set(wait: company.owner.auto_checkout_time).perform_later(id)
  end

  def encrypted_data_change_history
    self.versions.map { |version|
      ticket = version.reify
      ticket.encrypted_data
    }
  end

end
