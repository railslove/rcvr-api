module Owners
  class CompaniesController < Owners::ApplicationController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_owner!, except: %i[stats]
    before_action :authenticate_owner_with_api_token, only: %i[stats]

    def index
      companies = current_owner.companies

      render json: companies
    end

    def create
      company = current_owner.companies.create!(company_params)

      render json: company
    end

    def update
      company = current_owner.companies.find(params[:id])
      company.update!(company_params)

      render json: company
    end

    def show
      company = current_owner.companies.find(params[:id])

      render json: company
    end

    def stats
      company = @owner.companies.find(params[:company_id])

      stats = company.areas.map do |area|
        { area_name: area.name, area_test_exemption: area.test_exemption, checkin_count: area.tickets.open.count }
      end

      render json: stats
    end

    private

    def company_params
      params.require(:company).permit(:name, :street, :zip, :city, :menu_link, :menu_alias, :menu_pdf, :remove_menu_pdf, :privacy_policy_link, :need_to_show_corona_test, :location_type, :cwa_link_enabled, :cwa_crypto_seed)
    end

    def authenticate_owner_with_api_token
      authenticate_or_request_with_http_token do |token, _options|
        @owner = Owner.find_by(api_token: token)
      end
    end
  end
end
