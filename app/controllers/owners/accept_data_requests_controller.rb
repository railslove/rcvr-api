module Owners
  class AcceptDataRequestsController < Owners::ApplicationController
    def update
      data_request = current_owner.data_requests.find(params[:unaccepted_data_request_id])
      result = AcceptDataRequest.call(data_request: data_request)
      render json: result.data_request, include: { tickets: { methods: [:encrypted_data, :area_name, :encrypted_data_change_history] } }
    end
  end
end