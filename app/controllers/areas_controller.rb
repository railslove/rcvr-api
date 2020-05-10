class AreasController < ApplicationController
  before_action :authenticate_owner!

  def index
    areas = company.areas

    render json: areas
  end

  def create
    area = company.areas.create!(area_params)

    render json: area
  end

  def update
    area.update!(area_params)

    render json: area
  end

  def show
    render json: area
  end

  private

  def company
    current_owner.companies.find(params[:company_id])
  end

  def area
    current_owner.areas.find(params[:id])
  end

  def area_params
    params.require(:area).permit(:name)
  end
end
