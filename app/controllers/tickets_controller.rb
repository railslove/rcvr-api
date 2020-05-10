class TicketsController < ApplicationController
  def create
    ticket = Ticket.new(ticket_create_params)

    ticket.encrypted_private_key = ticket.company.encrypted_private_key
    ticket.save!

    render json: ticket
  end

  def update
    ticket = Ticket.find(params[:id])

    ticket.update!(ticket_update_params)

    render json: ticket
  end

  def risk_feed
    ticket_ids = Ticket.where(status: :at_risk).pluck(:id)

    render json: ticket_ids
  end

  private

  def ticket_update_params
    params.require(:ticket).permit(:id, :entered_at, :left_at)
  end

  def ticket_create_params
    params.require(:ticket).permit(:id, :area_id, :entered_at, :left_at, :encrypted_data, :public_key)
  end
end
