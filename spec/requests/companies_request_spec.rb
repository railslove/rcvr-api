require 'rails_helper'

RSpec.describe CompaniesController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }

  before do
    sign_in(owner)
  end

  context 'POST company' do
    subject do
      -> { post companies_path, params: { company: FactoryBot.attributes_for(:company) } }
    end

    it { is_expected.to change { Company.count }.by(1) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:no_content)
    end
  end
end
