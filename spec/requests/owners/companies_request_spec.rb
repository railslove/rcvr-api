require 'rails_helper'

RSpec.describe Owners::CompaniesController, type: :request do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }

  before do
    sign_in(owner)
  end

  context 'GET index' do
    before do
      FactoryBot.create(:company, owner: owner)
      FactoryBot.create(:company)

      get(owners_companies_path) 
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
      -> { post owners_companies_path, params: { company: FactoryBot.attributes_for(:company) } }
    end

    it { is_expected.to change { Company.count }.by(1) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:ok)
    end
  end

  context 'PATCH company' do
    let(:company) { FactoryBot.create(:company, owner: owner) }

    subject do
      -> { patch owners_company_path(company), params: { company: { name: 'New Name' } } }
    end

    it { is_expected.to change { company.reload.name }.to('New Name') }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:ok)
    end
  end

  context 'GET company' do
    let(:company) { FactoryBot.create(:company, owner: owner) }

    before { get owners_company_path(company) }

    it 'has the correct status' do
      expect(response).to have_http_status(:ok)
    end

    it 'Returns the company' do
      expect(JSON.parse(response.body)['id']).to eq(company.id)
    end
  end

  context 'GET stats' do
    let!(:company) { FactoryBot.create(:company, owner: owner) }
    let!(:area_1) { FactoryBot.create(:area, company: company) }
    let!(:area_2) { FactoryBot.create(:area, company: company) }
    let!(:closed_ticket) { FactoryBot.create(:ticket, area: area_1) }
    let!(:open_ticket_1) { FactoryBot.create(:ticket, area: area_1, left_at: nil) }
    let!(:open_ticket_2) { FactoryBot.create(:ticket, area: area_1, left_at: nil) }
    let!(:open_ticket_3) { FactoryBot.create(:ticket, area: area_2, left_at: nil) }
    let(:response_json) { JSON.parse(response.body) }

    before do
      owner.update_attribute(:api_token, 'test123')
      headers = { "Authorization": 'Bearer test123' }
      get owners_company_stats_path(company), headers: headers
    end

    it 'return stats for open tickets by area' do
      expect(response_json.size).to eq(2)
      expect(response_json.first['area_name']).to eq(area_1.name)
      expect(response_json.first['checkin_count']).to eq(2)
      expect(response_json.second['area_name']).to eq(area_2.name)
      expect(response_json.second['checkin_count']).to eq(1)
    end
  end
end
