class SessionsController < Devise::SessionsController
  respond_to :json

  before_action :stuff

  def stuff
    byebug
  end

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    head :no_content
  end
end
