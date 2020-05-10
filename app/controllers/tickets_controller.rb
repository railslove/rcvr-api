class TicketsController < ApplicationController
  def create
    ticket = Ticket.create!(ticket_params)

    render json: ticket
  end

  def update
    ticket = Ticket.find(params[:id])

    ticket.update!(ticket_params)

    render json: ticket
  end

  def risk_feed
    # TODO: Not sure if we should include (status: :confirmed) here
    ticket_ids = Ticket.where(status: :at_risk).pluck(:id)

    render json: ticket_ids
  end

  private

  def ticket_params
    params.require(:ticket).permit(:id, :company_id, :entered_at, :left_at)
  end
end
