require 'rails_helper'

RSpec.describe Owners::AreasController do
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

      get(owners_company_areas_path(company_id: company.id))
    end

    it 'Has the right response' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).map { |a| a['id'] })
        .to match_array(company.reload.areas.pluck(:id))
    end
  end

  context 'POST area' do
    subject do
      -> { post(owners_company_areas_path(company_id: company.id), params: { area: area_attributes }) }
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
      -> { patch(owners_area_path(area), params: { area: { name: 'New Name' } }) }
    end

    it { is_expected.to change { area.reload.name }.to('New Name') }

    it 'renders the area' do
      subject.call

      expect(JSON.parse(response.body)['id']).to eq(area.id)
    end
  end

  context 'GET qr pdf' do
    let!(:area) { FactoryBot.create(:area, company: company) }

    it 'requests the pdf from happy pdf' do
      stub_request(:get, %r{http://app.happypdf.com/api/pdf.*})

      get owners_area_path(area, format: :pdf)

      expect(WebMock).to have_requested(:get, %r{http://app.happypdf.com/api/pdf.*})
    end
  end

  context 'GET qr svg' do
    let!(:area) { FactoryBot.create(:area, company: company) }

    it 'returns svg data' do
      get owners_area_path(area, format: :svg)

      expect(response.content_type).to eq('image/svg')
      expect(response.body).to start_with("<?xml version=\"1.0\" standalone=\"yes\"?><svg version=\"1.1\"")
    end
  end

  context 'GET qr png' do
    let!(:area) { FactoryBot.create(:area, company: company) }

    it 'returns svg data' do
      get owners_area_path(area, format: :png)

      expect(response.content_type).to eq('image/png')
    end
  end
end
