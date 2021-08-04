class CreateDataRequest
  include Interactor
  include RequiredAttributes

  required_attributes %i[company from to reason]

  def call
    context.data_request = company.data_requests.create!({
      from: from,
      to: to,
      reason: reason,
      iris_client_name: context.iris_client_name,
      iris_data_authorization_token: context.iris_data_authorization_token,
      iris_connection_authorization_token: context.iris_connection_authorization_token,
      proxy_endpoint: context.proxy_endpoint
    })

    DataRequestMailer.with(
      owner: company.owner,
      company: company,
      data_request: context.data_request
    ).notification_email.deliver_later
  end

end