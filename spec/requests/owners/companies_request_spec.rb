require 'rails_helper'

RSpec.describe Owners::CompaniesController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
 
  before do
    sign_in(owner)
  end

  context 'GET index' do
    before do
      FactoryBot.create(:company, owner: owner)
      #FactoryBot.create(:company)

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
    before do
      @companycount = Company.count
      @owner = Owner.last
    end

    subject do
      -> { post owners_companies_path, params: { company: {name: "Acme Inc", street: "Strasse 1", zip: "12345", city: "Exampletown", need_to_show_corona_test: 24}} }
    end

    it "creates a new company" do
      subject.call

      expect(Company.count).to eq(@companycount + 1)
      #expect(Company.count).to eq(1)
      company = Company.last
      expect(company.owner.id).to eq(owner.id)
      expect(company.name).to eq("Acme Inc")
      expect(company.street).to eq("Strasse 1")
      expect(company.zip).to eq("12345")
      expect(company.city).to eq("Exampletown")
      expect(company.need_to_show_corona_test).to be(24)
    end

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

    before do
      owner.update_attribute(:api_token, 'test123')
      headers = { "Authorization": 'Bearer test123' }
      get owners_company_stats_path(company), headers: headers
    end

    subject { JSON.parse(response.body) }

    it 'return stats for open tickets by area' do
      expect(subject.size).to eq(2)
      expect(subject.first['area_name']).to eq(area_1.name)
      expect(subject.first['checkin_count']).to eq(2)
      expect(subject.second['area_name']).to eq(area_2.name)
      expect(subject.second['checkin_count']).to eq(1)
    end
  end
end
