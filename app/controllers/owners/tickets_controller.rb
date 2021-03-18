module Owners
  class TicketsController < Owners::ApplicationController
    def index
      from = Time.zone.parse(params.require(:from))
      to = Time.zone.parse(params.require(:to))

      tickets = company.tickets.includes(:area, :company).during(from..to).order(entered_at: :desc)

      render json: tickets
    rescue ActionController::ParameterMissing => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    private

    def company
      current_owner.companies.find(params[:company_id])
    end
  end
end
