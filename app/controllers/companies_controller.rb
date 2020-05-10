class CompaniesController < ApplicationController
  before_action :authenticate_owner!

  def index
    companies = current_owner.companies

    render json: companies
  end

  def create
    company = current_owner.companies.create!(company_params)

    render json: company
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end
