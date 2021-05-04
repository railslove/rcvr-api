module Owners
  class PasswordResetsController < ApplicationController
    skip_before_action :authenticate_owner!

    def request_reset
      Owner.find_by(email: params[:email])&.send_reset_password_instructions
      render json: {status: "OK"}
    end

    def reset
      return if params[:token].blank? || params[:password].blank?

      owner = Owner.with_reset_password_token(params[:token])

      raise ActiveRecord::RecordNotFound if owner.blank?

      owner.update!(password: params[:password])
      render json: { status: "OK" }
    end
  end
end
