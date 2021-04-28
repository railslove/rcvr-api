module Owners
  class UnacceptedDataRequestsController < Owners::ApplicationController

    def index
      render json: json_data
    end

    private

    def json_data
      current_owner.companies
        .filter { |company| company.data_requests.unaccepted.size > 0 }
        .map do |company|
          {
            id: company.id,
            name: company.name,
            unaccepted_data_requests: company.data_requests.unaccepted
          }
      end
    end

  end
end
