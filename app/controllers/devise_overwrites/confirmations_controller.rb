module DeviseOverwrites
  class ConfirmationsController < Devise::ConfirmationsController
    private

    def after_confirmation_path_for(resource_name, resource)
      'https://rcvr.app'
    end
  end
end
