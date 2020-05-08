require 'spec_helper'

RSpec.describe TicketsController do
  context 'POST create' do
    let!(:company) { FactoryBot.create(:company) }
    let(:ticket_attributes) { FactoryBot.attributes_for(:ticket, :open, company_id: company.id) }

    it 'creates a new ticket' do
      expect do
        post :create, params: { ticket: ticket_attributes }
      end.to change(Ticket, :count).by(1)
    end
  end

  context 'PATCH update' do
    let!(:ticket) { FactoryBot.create(:ticket, :open) }
    let(:left_at) { Time.zone.now }

    it 'updates an existing ticket' do
      post :update, params: { id: ticket.id, ticket: { left_at: left_at } }

      expect(ticket.reload.left_at.iso8601).to eql(left_at.iso8601)
    end
  end
end
