class AcceptDataRequest
  include Interactor
  include RequiredAttributes

  required_attributes %i[data_request]

  def call
    data_request.accept! unless data_request.accepted?
  end
end
