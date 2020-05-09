class Ticket < ApplicationRecord
  belongs_to :company

  validates :id, absence: true, on: :update, if: :id_changed? # Can never update id

  enum status: { neutral: 0, confirmed: 1, at_risk: 2 }

  def self.overlapping_time(time_range)
    # Three possibilities: They entered while the other person was there
    # .or they left while the other person was there
    # .or they arrived before and left after (they were there the entire time)
    Ticket.where(entered_at: time_range)
          .or(Ticket.where(left_at: time_range))
          .or(Ticket.where('entered_at <= ? AND left_at >= ?', time_range.begin, time_range.end))
  end

  def mark_as_confirmed!
    update!(status: :confirmed)

    Ticket
      .overlapping_time(entered_at..left_at)
      .where.not(id: id)
      .where(company_id: company_id)
      .find_each { |ticket| ticket.update!(status: :at_risk) }
  end
end
