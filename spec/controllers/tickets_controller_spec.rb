require 'spec_helper'

RSpec.describe TicketsController do
  context 'POST create' do
    let!(:company) { FactoryBot.create(:company) }
    let(:ticket_attributes) { FactoryBot.attributes_for(:ticket, :open, company_id: company.id) }

    it 'creates a new ticket' do
      expect do
        post :create, params: { ticket: ticket_attributes }
      end.to change(Ticket, :count).by(1)

      expect(response).to have_http_status(:no_content)
    end
  end

  context 'PATCH update' do
    let!(:ticket) { FactoryBot.create(:ticket, :open) }
    let(:left_at) { Time.zone.now }

    it 'updates an existing ticket' do
      post :update, params: { id: ticket.id, ticket: { left_at: left_at } }

      expect(response).to have_http_status(:no_content)
      expect(ticket.reload.left_at.iso8601).to eql(left_at.iso8601)
    end
  end

  context 'GET risk_feed' do
    let!(:ticket_neutral) { FactoryBot.create(:ticket, status: :neutral) }
    let!(:ticket_confirmed) { FactoryBot.create(:ticket, status: :confirmed) }
    let!(:ticket_at_risk) { FactoryBot.create(:ticket, status: :at_risk) }

    it 'returns only at_risk tickets' do
      get :risk_feed

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match_array([ticket_at_risk.id])
    end
  end
end