require 'jimson'

class IrisController
  extend Jimson::Handler

  def createDataRequest(params)
    company = Company.find(params["dataRequest"]["locationID"])

    data_request = DataRequest.create!(
      from: params["dataRequest"]["start"],
      to: params["dataRequest"]["end"],
      reason: params["dataRequest"]["requestDetails"],
      iris_client_name: params["_client"]["name"],
      iris_data_authorization_token: params["dataRequest"]["dataAuthorizationToken"],
      iris_connection_authorization_token: params["dataRequest"]["connectionAuthorizationToken"],
      company: company
    )

    {"_" => "OK"}
  rescue => error
    {"_" => "ERROR: #{error.message}"}
  end
end