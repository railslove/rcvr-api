class OwnersController < ApplicationController
  before_action :authenticate_owner!

  def update
    current_owner.update!(owner_params)

    render json: current_owner.reload
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :public_key, :encrypted_private_key)
  end
end
