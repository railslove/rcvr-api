require 'rails_helper'

RSpec.describe Owners::OwnersController do
  include_context 'api request authentication'

  let(:owner) { FactoryBot.create(:owner) }

  before do
    sign_in(owner)
  end

  context 'GET owner' do
    before do
      get(owners_owner_path())
    end

    it 'Has the right response' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(owner.id)
      expect(json["name"]).to eq(owner.name)
      expect(json["company_name"]).to eq(owner.company_name)
      expect(json["phone"]).to eq(owner.phone)
      expect(json["street"]).to eq(owner.street)
      expect(json["zip"]).to eq(owner.zip)
      expect(json["city"]).to eq(owner.city)
      expect(json["public_key"]).to eq(owner.public_key)
      expect(json["affiliate"]).to eq(owner.affiliate)
      expect(json["frontend_url"]).to eq(owner.frontend_url)
      expect(json["trial_ends_at"]).to eq(owner.trial_ends_at)
      expect(json["block_at"]).to eq(owner.block_at)
      expect(json["can_use_for_free"]).to eq(owner.can_use_for_free)
    end
  end

  context 'UPDATE owner' do
    it "updates the data" do
      patch(owners_owner_path(), params: { owner: { name: 'New Name' } })
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      owner.reload

      expect(owner.name).to eq("New Name")
      expect(json["id"]).to eq(owner.id)
      expect(json["name"]).to eq(owner.name)
    end
  end
end