class AreasController < ApplicationController
  def show
    area = Area.find(params[:id])

    render json: area
  end
end
