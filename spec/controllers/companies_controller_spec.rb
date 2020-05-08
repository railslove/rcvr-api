require 'rails_helper'

RSpec.describe CompaniesController do
  context 'POST company' do
    it 'creates a company' do
      expect do
        post :create, params: { company: FactoryBot.attributes_for(:company) }
      end.to change(Company, :count).by(1)
    end
  end
end
