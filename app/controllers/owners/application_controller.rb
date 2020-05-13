module Owners
  class ApplicationController < ::ApplicationController
    before_action :authenticate_owner!
  end
end
