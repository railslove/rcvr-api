require 'rails_helper'

RSpec.describe TicketsController do
  context 'POST create' do
    let!(:company) { FactoryBot.create(:company) }
    let(:ticket_attributes) { FactoryBot.attributes_for(:ticket, :open, company_id: company.id) }

    subject { -> { post tickets_path, params: { ticket: ticket_attributes } } }

    it { is_expected.to change(Ticket, :count).by(1) }

    it 'Has the right status and content' do
      subject.call

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  context 'PATCH update' do
    let!(:ticket) { FactoryBot.create(:ticket, :open) }
    let(:left_at) { Time.zone.now }

    it 'updates an existing ticket' do
      patch ticket_path(ticket), params: { id: ticket.id, ticket: { left_at: left_at } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
      expect(ticket.reload.left_at.iso8601).to eql(left_at.iso8601)
    end
  end

  context 'GET risk_feed' do
    let!(:ticket_neutral) { FactoryBot.create(:ticket, status: :neutral) }
    let!(:ticket_at_risk) { FactoryBot.create(:ticket, status: :at_risk) }

    it 'returns only at_risk tickets' do
      get risk_feed_path

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match_array([ticket_at_risk.id])
    end
  end
end
