module Owners
  class CompaniesController < Owners::ApplicationController
    before_action :authenticate_owner!

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

    private

    def company_params
      params.require(:company).permit(:name, :menu_link, :menu_pdf)
    end
  end
end
