# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owners::UnacceptedDataRequestsController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:a_company) { FactoryBot.create(:company, owner: owner) }
  let(:b_company) { FactoryBot.create(:company, owner: owner) }
  let(:c_company) { FactoryBot.create(:company) }
  let(:area) { FactoryBot.create(:area, company: a_company) }

  before do
    sign_in(owner)
  end

  context "GET unaccepted_data_request index" do
    let!(:data_request) do
      FactoryBot.create(:ticket, area: area, encrypted_data: "data", entered_at: Time.zone.now.yesterday - 2.hours, left_at: Time.zone.now.yesterday - 1.hour)
      FactoryBot.create(:data_request,
                        company: a_company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday,
                        accepted_at: Time.zone.now.yesterday)
      FactoryBot.create(:data_request,
                        company: b_company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday,
                        accepted_at: Time.zone.now.yesterday)
      FactoryBot.create(:data_request,
                        company: c_company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday)
      FactoryBot.create(:data_request,
                        company: a_company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday)
    end

    before do
      get owners_unaccepted_data_requests_path()
    end

    subject { JSON.parse(response.body) }

    it "has the correct data" do
      expect(subject.length).to eq(1)
      item = subject.first
      expect(item["id"]).to eq(a_company.id)
      expect(item["name"]).to eq(a_company.name)
      expect(item["unaccepted_data_requests"].length).to eq(1)
      expect(item["unaccepted_data_requests"][0]["id"]).to eq(data_request.id)
    end
  end
end