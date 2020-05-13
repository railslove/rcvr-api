module DeviseOverwrites
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      build_resource(sign_up_params)

      resource.save!

      sign_in resource

      render json: resource
    end

    private

    def sign_up_params
      params.require(:owner).permit(:email, :password, :name)
    end
  end
end
