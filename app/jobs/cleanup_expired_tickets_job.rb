class CleanupExpiredTicketsJob < ApplicationJob
  queue_as :default

  def perform
    Ticket.where('created_at <= ?', 4.weeks.ago).destroy_all
  end
end
