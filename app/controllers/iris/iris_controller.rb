class Iris::IrisController < ApplicationController

  @@WFD_API_KEY_HEADER = 'x-wfd-api-key'

  before_action :authenticate

  private

  def authenticate

    if ENV['X_WFD_API_KEY'].nil? or ! ENV['X_WFD_API_KEY'].eql?(request.headers[@@WFD_API_KEY_HEADER]) then
      render status: 401
    end

  end

end
