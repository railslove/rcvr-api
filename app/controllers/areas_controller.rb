class AreasController < ApplicationController
  before_action :load_company

  def index
    areas = @company.areas

    render json: areas
  end

  def create
    area = @company.areas.create!(area_params)

    render json: area
  end

  private

  def load_company
    @company = current_owner.companies.find(params[:company_id])
  end

  def area_params
    params.require(:area).permit(:name)
  end
end
