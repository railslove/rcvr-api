require 'rails_helper'

RSpec.describe AreasController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }
  let(:area_attributes) { FactoryBot.attributes_for(:area) }

  before do
    sign_in(owner)
  end

  context 'GET index' do
    before do
      FactoryBot.create(:area, company: company)
      FactoryBot.create(:area)

      get(company_areas_path(company_id: company.id))
    end

    it 'Has the right response' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).map { |a| a['id'] })
        .to match_array(company.reload.areas.pluck(:id))
    end
  end

  context 'POST area' do
    subject do
      -> { post(company_areas_path(company_id: company.id), params: { area: area_attributes }) }
    end

    it { is_expected.to change { company.reload.areas.count }.by(1) }

    it 'has the right http status code' do
      subject.call

      expect(response).to have_http_status(:ok)
    end
  end

  context 'UPDATE area' do
    let!(:area) { FactoryBot.create(:area, company: company) }

    subject do
      -> { patch(area_path(area), params: { area: { name: 'New Name' } }) }
    end

    it { is_expected.to change { area.reload.name }.to('New Name') }

    it 'Has renders the area' do
      subject.call

      expect(JSON.parse(response.body)['id']).to eq(area.id)
    end
  end

  context 'GET area' do
    let!(:area) { FactoryBot.create(:area, company: company) }

    before { get area_path(area) }

    it 'Has renders the area' do
      expect(JSON.parse(response.body)['id']).to eq(area.id)
    end
  end
end
