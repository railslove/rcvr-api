module DeviseOverwrites
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      respond_with_navigational(resource) do
        redirect_to(after_confirmation_path_for(resource_name, resource))
      end
    end

    private

    def after_confirmation_path_for(resource_name, resource)
      error_query = { error: resource.errors.full_messages }.to_param
      path = resource.public_key.blank? ?
        "/business/setup/key-intro" : "/business/dashboard"

      URI(ENV['FRONTEND_URL']).tap do |uri|
        uri.query = error_query
        uri.path = path
      end.to_s
    end
  end
end
