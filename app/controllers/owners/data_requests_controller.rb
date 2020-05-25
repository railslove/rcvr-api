module Owners
  class DataRequestsController < Owners::ApplicationController
    def show
      data_request = current_owner.data_requests.find(params[:id])

      if data_request.accepted?
        render json: data_request.to_json(include: :tickets)
      else
        render json: data_request
      end
    end

    def index
      render json: company.data_requests
    end

    private

    def company
      current_owner.companies.find(params[:company_id])
    end
  end
end
