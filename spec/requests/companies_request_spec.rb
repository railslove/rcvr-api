require 'rails_helper'

RSpec.describe CompaniesController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }

  before do
    sign_in(owner)
  end

  context 'GET index' do
    before do
      FactoryBot.create(:company, owner: owner)
      FactoryBot.create(:company)

      get(companies_path) 
    end

    it 'Has the correct http status' do
      expect(response).to have_http_status(:ok)
    end

    it 'Return the companies of the current user' do
      expect(JSON.parse(response.body).map { |c| c['id'] })
        .to match_array(owner.reload.companies.pluck(:id))
    end
  end

  context 'POST company' do
    subject do
      -> { post companies_path, params: { company: FactoryBot.attributes_for(:company) } }
    end

    it { is_expected.to change { Company.count }.by(1) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:ok)
    end
  end
end
