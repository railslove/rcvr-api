class CompaniesController < ApplicationController
  def create
    Company.create(company_params)
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end
