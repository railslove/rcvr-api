class CleanupExpiredTicketsJob < ApplicationJob
  queue_as :default

  def perform
    Ticket
      .not_expired
      .where('created_at <= ?', 4.weeks.ago)
      .update_all(status: :expired, encrypted_data: nil, public_key: nil)
  end
end
