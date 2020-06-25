module DeviseOverwrites
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      self.owner = resource_class.confirm_by_token(params[:confirmation_token])
      yield owner if block_given?

      respond_with_navigational(owner) do
        redirect_to(after_confirmation_path_for(resource_name, owner))
      end
    end

    private

    def after_confirmation_path_for(resource_name, owner)
      error_query = { error: owner.errors.full_messages }.to_param
      path = owner.public_key.blank? ?
        "/business/setup/key-intro" : "/business/dashboard"

      URI(owner.frontend_url).tap do |uri|
        uri.query = error_query
        uri.path = path
      end.to_s
    end
  end
end
