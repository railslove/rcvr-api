require 'rails_helper'

RSpec.describe Owners::OwnersController do

  let(:owner) { FactoryBot.create(:owner) }

  context 'POST request_reset' do
    before do
      post(owners_request_password_reset_path(email: owner.email))
    end

    it 'Has the right response' do
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      owner.reload
      expect(owner.reset_password_token).not_to be_nil
    end
  end

  context "POST reset_password" do
    let!(:reset_token) do
      owner.send_reset_password_instructions
    end

    it "will change the password and removes the reset token if the token is correct" do
      old_password = owner.encrypted_password

      result = post(owners_reset_password_path(token: reset_token, password: "example1234"))
      json = JSON.parse(response.body)
      owner.reload

      expect(response.status).to eq 200
      expect(json["status"]).to eq "OK"
      expect(owner.encrypted_password).not_to eq(old_password)
      expect(owner.reset_password_token).to be_nil
    end

    it "will raise an error if the password is not long enough" do
      old_password = owner.encrypted_password

      result = post(owners_reset_password_path(token: reset_token, password: "wrong"))
      owner.reload

      expect(response.status).to eq 422
      expect(owner.encrypted_password).to eq(old_password)
    end
  end
end
