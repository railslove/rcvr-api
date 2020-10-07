# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owners::DataRequestsController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }

  before do
    sign_in(owner)
  end

  context 'POST data_request' do
    subject do
      -> { post owners_company_data_requests_path(company_id: company.id), params: { data_request: { reason: 'for fun' } } }
    end

    it { is_expected.to change { DataRequest.count }.by(1) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:ok)
    end

    it 'creates a new DataRequest for the last 2 hours' do
      subject.call

      new_data_request = DataRequest.last

      expect(new_data_request.from).to be_within(1.seconds).of(Time.zone.now - 4.hours)
      expect(new_data_request.to).to be_within(1.seconds).of(Time.zone.now)
      expect(new_data_request.accepted_at).to be_within(1.seconds).of(Time.zone.now)
      expect(new_data_request.reason).to eq('for fun')
    end
  end
end
