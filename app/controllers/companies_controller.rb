class CompaniesController < ApplicationController
  before_action :authenticate_owner!

  def create
    current_owner.companies.create!(company_params)
  end

  private

  def company_params
    params.require(:company).permit(:name)
  end
end
