class TicketsController < ApplicationController
  def create
    ticket = Ticket.create!(ticket_params)

    ticket.schedule_auto_checkout_job

    render json: ticket
  rescue ActiveRecord::RecordNotUnique
    # idempotency, but we dont update the ticket since the checkout time would be pushed back unecessarily
    render json: Ticket.find(ticket_params[:id])
  end

  def update
    ticket = Ticket.find(params[:id])

    ticket.update!(ticket_params)

    render json: ticket
  rescue ActiveRecord::RecordInvalid
    # idempotency
    # TODO: Make sure this is only idempotent for the write only once validator
    render json: Ticket.find(params[:id])
  end

  def risk_feed
    ticket_ids = Ticket.where(status: :at_risk).pluck(:id)

    render json: ticket_ids
  end

  private

  def ticket_params
    params.require(:ticket).permit(:id, :area_id, :entered_at, :left_at, :cwa_checked_in, :encrypted_data, :public_key, :accepted_privacy_policy)
  end
end
