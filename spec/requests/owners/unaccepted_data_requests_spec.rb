# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owners::UnacceptedDataRequestsController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }
  let(:other_company) { FactoryBot.create(:company, owner: owner) }
  let(:area) { FactoryBot.create(:area, company: company) }

  before do
    sign_in(owner)
  end

  context "GET unaccepted_data_request index" do
    let!(:data_request) do
      FactoryBot.create(:ticket, area: area, encrypted_data: "data", entered_at: Time.zone.now.yesterday - 2.hours, left_at: Time.zone.now.yesterday - 1.hour)
      FactoryBot.create(:data_request,
                        company: company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday,
                        accepted_at: Time.zone.now.yesterday)
      FactoryBot.create(:data_request,
                        company: other_company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday)
      FactoryBot.create(:data_request,
                        company: company,
                        from: Time.zone.now.yesterday - 4.hours,
                        to: Time.zone.now.yesterday)
    end

    before do
      get owners_company_unaccepted_data_requests_path(company_id: company.id)
    end

    subject { JSON.parse(response.body) }

    it "has the correct data" do
      expect(subject.length).to eq(1)
      expect(subject.map{|item| item["id"]}).to eq([data_request.id])
    end
  end
end