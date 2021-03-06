require 'rails_helper'

RSpec.describe AffiliatesController do
  context 'Show affiliate' do
    let(:affiliate) { FactoryBot.create(:affiliate) }

    it 'is possible to fetch affiliate information by code' do
      code = affiliate.code
      logo = affiliate.logo

      get '/affiliates/' + code

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)
      expect(res['name']).to eq(affiliate.name)
      expect(res['logo_link']).to eq(affiliate.logo_link)
      expect(res['logo_url']).to_not be_nil

    end

    it 'is not possible to fetch affiliate information if code is wrong' do
      get '/affiliates/notexisting'
      expect(response.status).to eq(404)
    end

  end

end
