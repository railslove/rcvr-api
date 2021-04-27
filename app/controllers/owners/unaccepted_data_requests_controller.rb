module Owners
  class UnacceptedDataRequestsController < Owners::ApplicationController

    def index
      render json: json_data
    end

    private

    def json_data
      current_owner.companies.map {|company|
        {
          id: company.id,
          name: company.name,
          unaccepted_data_requests: company.data_requests.unaccepted
        }
      }.filter {|item| 
        item[:unaccepted_data_requests].length > 0
      }
    end

  end
end
