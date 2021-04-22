# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owners::AcceptDataRequestsController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }
  let(:company) { FactoryBot.create(:company, owner: owner) }
  let(:other_company) { FactoryBot.create(:company, owner: owner) }
  let(:area) { FactoryBot.create(:area, company: company) }

  before do
    sign_in(owner)
  end

  context "PATCH accepted_data_request update" do
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
      patch owners_unaccepted_data_request_accept_path(unaccepted_data_request_id: data_request.id)
    end

    subject { JSON.parse(response.body) }

    it "has the correct data" do
      expect(subject['id']).to eq(data_request.id)
      expect(data_request.reload.accepted?).to be(true)
    end
  end
end