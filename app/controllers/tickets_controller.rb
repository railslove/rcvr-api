class TicketsController < ApplicationController
  def create
    @ticket = Ticket.create!(ticket_params)
  end

  def update
    @ticket = Ticket.find(params[:id])

    @ticket.update!(ticket_params)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:id, :company_id, :entered_at, :left_at)
  end
end
