module DeviseOverwrites
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      build_resource(sign_up_params)

      resource.trial_ends_at = 14.days.from_now
      resource.block_at = 16.days.from_now
      resource.frontend = Frontend.find_by(frontend_params)

      resource.save!

      sign_in resource

      render json: resource
    end

    private

    def sign_up_params
      params.require(:owner).permit(:email, :password, :name, :affiliate)
    end

    def frontend_params
      params.require(:frontend).permit(:url)
    end
  end
end
