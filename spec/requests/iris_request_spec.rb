require 'rails_helper'

RSpec.describe IrisController do
  context 'createDataRequest' do
    it 'stores a iris data request with all parameters' do
      company = FactoryBot.create(:company)
      expect {
        post '/irisrpc/', params: {
          "jsonrpc" => "2.0", 
          "id": "id-2",
          "method": "createDataRequest",
          "params": [
            {
              "_client": {
                "name": "clientName"
              },
              "dataRequest": {
                "start": "2021-08-01T12:30:00.000000",
                "end": "2021-08-01T15:00:00.000000",
                "requestDetails": "Corona Fall Dringend",
                "dataAuthorizationToken": "data-token",
                "connectionAuthorizationToken": "connection-token",
                "locationID": company.id
              }
            }
          ] 
        }.to_json
      }.to change(DataRequest, :count).by(1)

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res["id"]).to eql("id-2")
      expect(res["result"]).to eql({"_" => "OK"})

      data_request = DataRequest.last

      expect(data_request.company_id).to eql(company.id)
      expect(data_request.from).to be_within(1.second).of DateTime.new(2021,8,1,12,30,0, '+2:00')
      expect(data_request.to).to be_within(1.second).of DateTime.new(2021,8,1,15,0,0, '+2:00')
      expect(data_request.iris_client_name).to eql("clientName")
      expect(data_request.iris_data_authorization_token).to eql("data-token")
      expect(data_request.iris_connection_authorization_token).to eql("connection-token")
      expect(data_request.accepted?).to be false
    end

    it 'returns an error if the company cannot be found' do
      expect {
        post '/irisrpc/', params: {
          "jsonrpc" => "2.0", 
          "id": "id-2",
          "method": "createDataRequest",
          "params": [
            {
              "_client": {
                "name": "clientName"
              },
              "dataRequest": {
                "start": "2021-08-01T12:30:00.000000",
                "end": "2021-08-01T15:00:00.000000",
                "requestDetails": "Corona Fall Dringend",
                "dataAuthorizationToken": "data-token",
                "connectionAuthorizationToken": "connection-token",
                "locationID": "unkonwn"
              }
            }
          ] 
        }.to_json
      }.to change(DataRequest, :count).by(0)

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res["id"]).to eql("id-2")
      expect(res["result"]).to eql({"_" => "ERROR: Couldn't find Company with 'id'=unkonwn"})
    end

    it 'returns an error if a parameter is missing' do
      company = FactoryBot.create(:company)
      expect {
        post '/irisrpc/', params: {
          "jsonrpc" => "2.0", 
          "id": "id-2",
          "method": "createDataRequest",
          "params": [
            {
              "_client": {
                "name": "clientName"
              },
              "dataRequest": {
                "end": "2021-08-01T15:00:00.000000",
                "requestDetails": "Corona Fall Dringend",
                "dataAuthorizationToken": "data-token",
                "connectionAuthorizationToken": "connection-token",
                "locationID": company.id
              }
            }
          ] 
        }.to_json
      }.to change(DataRequest, :count).by(0)

      expect(response).to have_http_status(:ok)
      res = JSON.parse(response.body)

      expect(res["id"]).to eql("id-2")
      expect(res["result"]).to eql({"_" => "ERROR: Validation failed: From can't be blank"})
    end
  end
end
