class CreateDataRequest
  include Interactor
  include RequiredAttributes

  required_attributes %i[company from to reason]

  def call
    context.data_request = company.data_requests.create!({from: from, to: to, reason: reason})
    DataRequestMailer.with(
      owner: company.owner,
      company: company, 
      data_request: context.data_request
    ).notification_email.deliver_later
  end

end