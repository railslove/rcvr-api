module Owners
  class RateLimitError < StandardError; end

  class ApplicationController < ::ApplicationController
    rescue_from RateLimitError, with: :too_many_requests

    before_action :authenticate_owner!

    private

    def too_many_requests
      head :too_many_requests
    end
  end
end
