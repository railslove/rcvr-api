# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owners::DataRequestsController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }
  let(:area) { FactoryBot.create(:area, company: company) }

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

        expect(new_data_request.from).to eq(Time.zone.now - 48.hours)
        expect(new_data_request.to).to eq(Time.zone.now)
        expect(new_data_request.accepted_at).to eq(Time.zone.now)
        expect(new_data_request.reason).to eq('for fun')
      end
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


  context "GET result of data_request" do
    let(:data_request) do
      FactoryBot.create(:ticket, area: area, encrypted_data: "data", entered_at: Time.zone.now.yesterday - 2.hours, left_at: Time.zone.now.yesterday - 1.hour)
      FactoryBot.create(:data_request,
                        company: company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday,
                        accepted_at: Time.zone.now.yesterday)
    end

    before do
      get owners_data_request_path(data_request.id)
    end

    subject { JSON.parse(response.body) }

    it "has the correct data" do
      expect(subject["id"]).to eq(data_request.id)
      expect(subject["tickets"].size).to eq(1)
      ticket = subject["tickets"].first
      expect(ticket["encrypted_data"]).to eq("data")
      expect(ticket["area_id"]).to eq(area.id)
      expect(ticket["area_name"]).to eq(area.name)
    end
  end
end
