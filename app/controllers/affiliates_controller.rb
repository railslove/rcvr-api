class AffiliatesController < ApplicationController
  def show
    render json: Affiliate.find_by!(code: params[:code])
  end
end
