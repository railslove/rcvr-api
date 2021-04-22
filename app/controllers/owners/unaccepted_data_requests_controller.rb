module Owners
  class UnacceptedDataRequestsController < Owners::ApplicationController

    def index
      render json: company.data_requests.unaccepted
    end

    private

    def company
      current_owner.companies.find(params[:company_id])
    end

  end
end
