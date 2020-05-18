class TicketsController < ApplicationController
  def create
    ticket = Ticket.create!(ticket_params)

    ticket.schedule_auto_checkout_job

    render json: ticket
  end

  def update
    ticket = Ticket.find(params[:id])

    ticket.update!(ticket_params)

    render json: ticket
  end

  def risk_feed
    ticket_ids = Ticket.where(status: :at_risk).pluck(:id)

    render json: ticket_ids
  end

  private

  def ticket_params
    params.require(:ticket).permit(:id, :area_id, :entered_at, :left_at, :encrypted_data, :public_key, :accepted_privacy_policy)
  end
end
