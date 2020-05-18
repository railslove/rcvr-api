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

      respond_to do |format|
        format.pdf do
          qr_code_pdf = QrCodePdf.call(area: area)

          render pdf: qr_code_pdf.file_name, data: qr_code_pdf.data
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
