module Owners
  class TicketsController < Owners::ApplicationController
    def index
      tickets = company.tickets

      render json: tickets
    end

    private

    def company
      current_owner.companies.find(params[:company_id])
    end
  end
end
