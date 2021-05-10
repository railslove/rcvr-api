require 'base64'

module Cwa
  class GenerateUrl
    include Interactor
    include RequiredAttributes

    required_attributes %i[company]

    def call
      payload = Base64.urlsafe_encode64(Cwa::QrCodePayload.new(company).serialize)
      context.url = "https://e.coronawarn.app?v=1##{payload}"
    end
  end
end