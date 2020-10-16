require 'rails_helper'

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let(:frontend) { FactoryBot.create(:frontend) }
  let(:params) do
    {
      owner: {
        email: 'owner@example.com',
        company_name: 'Railslove',
        phone: '0221666666666',
        password: 'password',
        affiliate: 'AFFNAME'
      },
      frontend: {
        url: frontend.url
      }
    }
  end

  context 'when owner is unauthenticated' do
    before { post url, params: params }

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('AFFNAME')
    end

    it 'creates a new owner' do
      expect(Owner.count).to eq(1)
    end

    it 'Signs the owner in directly' do
      expect(response.headers['Authorization']).to be_present

    end
  end

  context 'when owner already exists' do
    let!(:owner) { FactoryBot.create(:owner, email: params[:owner][:email]) }

    before { post url, params: params }

    it 'returns unprocessable_entity status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
