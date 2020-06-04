module Owners
  class AreasController < Owners::ApplicationController
    before_action :authenticate_owner!, except: :show

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
      area = Area.find(params[:id])
      qr_code = QrCode.call(area: area, format: request.format.symbol) unless request.format.symbol == :json

      respond_to do |format|
        format.pdf do
          render pdf: qr_code.file_name, data: qr_code.data
        end

        format.svg do
          send_data qr_code.data, type: 'image/svg', disposition: 'attachment', filename: qr_code.file_name
        end

        format.png do
          send_data qr_code.data, type: 'image/png', disposition: 'attachment', filename: qr_code.file_name
        end

        format.json do
          render json: area
        end
      end
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
end
