class Iris::IrisController < ApplicationController

  include ActiveSupport::SecurityUtils

  @@WFD_API_KEY_HEADER = 'x-wfd-api-key'
  @@WFD_API_KEY = ENV['X_WFD_API_KEY']

  before_action :authenticate

  private

  def authenticate

    if ! secure_compare(@@WFD_API_KEY, request.headers[@@WFD_API_KEY_HEADER] || '') then
      render status: 401
    end

  end

end
