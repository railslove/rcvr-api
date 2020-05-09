class OwnersController < ApplicationController
  before_action :authenticate_owner!

  def update
    current_owner.update!(owner_params)
  end

  private

  def owner_params
    params.require(:owner).permit(:name, :public_key)
  end
end
