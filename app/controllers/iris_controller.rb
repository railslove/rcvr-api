require 'jimson'

class IrisController
  extend Jimson::Handler

  def createDataRequest(params)
    Rails.logger.debug("Connected to Create date request controller, params:#{params}")
    company = Company.find(params["dataRequest"]["locationID"])
    Rails.logger.debug("Found company, company:#{company}")
    CreateDataRequest.call(
      company: company,
      from: params["dataRequest"]["start"],
      to: params["dataRequest"]["end"],
      reason: params["dataRequest"]["requestDetails"],
      iris_client_name: params["_client"]["name"],
      iris_data_authorization_token: params["dataRequest"]["dataAuthorizationToken"],
      iris_connection_authorization_token: params["dataRequest"]["connectionAuthorizationToken"],
    )

    {"_" => "OK"}
  rescue => error
    {"_" => "ERROR: #{error.message}"}
  end
end