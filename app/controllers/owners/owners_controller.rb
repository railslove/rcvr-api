module Owners
  class OwnersController < Owners::ApplicationController
    before_action :authenticate_owner!

    def show
      render json: current_owner
    end

    def update
      current_owner.update!(owner_params)

      render json: current_owner.reload
    end

    private

    def owner_params
      params.require(:owner).permit(:name, :company_name, :street, :zip, :city, :phone, :public_key)
    end
  end
end
