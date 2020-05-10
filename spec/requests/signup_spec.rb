require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let(:params) do
    {
      owner: {
        email: 'owner@example.com',
        password: 'password'
      }
    }
  end

  context 'when owner is unauthenticated' do
    before { post url, params: params }

    it 'returns 204' do
      expect(response.status).to eq 204
    end

    it 'creates a new owner' do
      expect(Owner.count).to eq(1)
    end
  end

  context 'when owner already exists' do
    before do
      FactoryBot.create(:owner, email: params[:owner][:email])
      post url, params: params
    end

    it 'returns bad request status' do
      expect(response.status).to eq 422
    end
  end
end
