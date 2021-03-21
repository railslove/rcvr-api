class Iris::IrisController < ApplicationController

  WFD_API_KEY_HEADER = 'x-wfd-api-key'.freeze
  @@WFD_API_KEY = ENV['X_WFD_API_KEY']

  before_action :authenticate

  private

  def authenticate

    auth = request.headers[WFD_API_KEY_HEADER]
    if @@WFD_API_KEY.blank? || auth.blank? || ! ActiveSupport::SecurityUtils.secure_compare(@@WFD_API_KEY, auth)
      render status: 401
    end

  end

end
