module Owners
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate_owner!

    def request_reset
      Owner.find_by(email: params[:email])&.send_reset_password_instructions
    end

    def reset
      return if reset_params[:token].blank?

      owner = Owner.with_reset_password_token(reset_params[:token])

      raise ActiveRecord::RecordNotFound if owner.blank?

      owner.update(password: reset_params[:password])
    end

    private

    def reset_params
      params.require(:password).permit(:token, :password)
    end
  end
end
