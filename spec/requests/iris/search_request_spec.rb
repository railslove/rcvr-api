require 'rails_helper'

RSpec.describe "Iris::Searches", type: :request do

  context 'API Key Check' do

    it 'should return 401 if no api key is set' do
      get '/iris/search/Berlin'
      expect(response.status).to eq(401)
    end

    it 'should return 200 if api key is set' do
      get '/iris/search/Berlin', headers: { 'x-wfd-api-key': 'test' }
      expect(response.status).to eq(200)
    end

  end

  context 'search results' do

    let(:owner) { FactoryBot.create(:owner) }
    let(:company) { FactoryBot.create(:company, owner: owner) }

    it 'should return correct search results when searching for company name' do

      response = search_and_extract (company.name)
      expect(response.length).to eq(1)
      result = response.first

      assert (result)
    end

    it 'should return correct search results when searching for owner official name' do

      company.save!

      response = search_and_extract (owner.company_name)
      expect(response.length).to eq(1)
      result = response.first

      assert (result)

    end

    it 'should ignore case when searching for company name' do

      response = search_and_extract (company.name.downcase)
      expect(response.length).to eq(1)
      result = response.first

      assert (result)

    end

    it 'should ignore case when searching for owner official company name' do

      company.save!

      response = search_and_extract (owner.company_name.downcase)
      expect(response.length).to eq(1)
      result = response.first

      assert (result)

    end


    private

    def assert (result)
      # Expected response format https://github.com/wirfuerdigitalisierung/documentation/blob/0815402ae2189cad167be7b7e129ec49c389032a/specs.yaml#L165
      expect(result['id']).to eq(company.id)
      expect(result['name']).to eq(company.name)
      expect(result['contact']['address']).to eq({ "city" => "", "street" => "", "zip" => "" })
    end

    def search_and_extract (search_string)
      get "/iris/search/#{URI::encode(search_string)}", headers: { 'x-wfd-api-key': 'test' }
      expect(response.status).to eq(200)
      JSON.parse(response.body)
    end

  end

end
