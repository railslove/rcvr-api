module Owners
  class DataRequestsController < Owners::ApplicationController
    def show
      data_request = current_owner.data_requests.find(params[:id])

      if data_request.accepted?
        render json: data_request, include: { tickets: { methods: :encrypted_data } }
      else
        render json: data_request
      end
    end

    def index
      render json: company.data_requests
    end

    def create
      create_params = data_request_params.merge(
        from: Time.zone.now - current_owner.auto_checkout_time,
        to: Time.zone.now,
        accepted_at: Time.zone.now
      )
      data_request = company.data_requests.create!(create_params)

      render json: data_request
    end

    private

    def company
      current_owner.companies.find(params[:company_id])
    end

    def data_request_params
      params.require(:data_request).permit(:reason)
    end
  end
end
