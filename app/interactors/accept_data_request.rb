class AcceptDataRequest
  include Interactor
  include RequiredAttributes

  required_attributes %i[data_request]

  def call
    unless data_request.accepted?
      data_request.accept!
    end
    context.data_request = data_request
  end
end
