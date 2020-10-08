# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owners::DataRequestsController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }

  before do
    sign_in(owner)
  end

  context 'POST first data_request' do
    subject do
      -> { post owners_company_data_requests_path(company_id: company.id), params: { data_request: { reason: 'for fun' } } }
    end

    it { is_expected.to change { DataRequest.count }.by(1) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:ok)
    end

    it 'creates a new DataRequest for the last 2 hours' do
      freeze_time do
        subject.call

        new_data_request = DataRequest.last

        expect(new_data_request.from).to eq(Time.zone.now - 4.hours)
        expect(new_data_request.to).to eq(Time.zone.now)
        expect(new_data_request.accepted_at).to eq(Time.zone.now)
        expect(new_data_request.reason).to eq('for fun')
      end
    end
  end

  context 'POST further data_request on the same day' do
    let!(:previous_request) do
      FactoryBot.create(:data_request,
                        company: company,
                        from: Time.zone.now - 4.hours,
                        to: Time.zone.now,
                        accepted_at: Time.zone.now)
    end

    subject do
      -> { post owners_company_data_requests_path(company_id: company.id), params: { data_request: { reason: 'for abuse' } } }
    end

    it { is_expected.to change { DataRequest.count }.by(0) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:too_many_requests)
    end
  end

  context 'POST further data_request on another day' do
    let!(:previous_request) do
      FactoryBot.create(:data_request,
                        company: company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday,
                        accepted_at: Time.zone.now.yesterday)
    end

    subject do
      -> { post owners_company_data_requests_path(company_id: company.id), params: { data_request: { reason: 'new day' } } }
    end

    it { is_expected.to change { DataRequest.count }.by(1) }

    it 'Has the correct http status' do
      subject.call

      expect(response).to have_http_status(:ok)
    end
  end
end
