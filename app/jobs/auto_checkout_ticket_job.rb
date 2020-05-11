class AutoCheckoutTicketJob < ApplicationJob
  discard_on ActiveRecord::RecordNotFound

  def perform(ticket_id)
    Ticket.open.find(ticket_id).update(left_at: Time.zone.now)
  end
end
