module DeviseOverwrites
  class ConfirmationsController < Devise::ConfirmationsController
    private

    def after_confirmation_path_for(resource_name, resource)
      if resource.public_key.blank?
        redirect_to 'https://rcvr.app/business/setup/key-intro'
      else
        redirect_to 'https://rcvr.app/business/dashboard'
      end
    end
  end
end
