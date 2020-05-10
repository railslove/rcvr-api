class AreasController < ApplicationController
  before_action :load_company

  def create
    @company.areas.create!(area_params)
  end

  private

  def load_company
    @company = current_owner.companies.find(params[:company_id])
  end

  def area_params
    params.require(:area).permit(:name)
  end
end
