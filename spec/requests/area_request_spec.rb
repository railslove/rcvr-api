require 'spec_helper'

RSpec.describe AreasController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }
  let(:area_attributes) { FactoryBot.attributes_for(:area) }

  before do
    sign_in(owner)
  end

  context 'POST area' do
    subject do
      -> { post(company_areas_path(company_id: company.id), params: { area: area_attributes }) }
    end

    it { is_expected.to change { company.reload.areas.count }.by(1) }

    it 'has the right http status code' do
      subject.call

      expect(response).to have_http_status(:no_content)
    end
  end
end
