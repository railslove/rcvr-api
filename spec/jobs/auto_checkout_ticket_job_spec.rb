require 'rails_helper'

RSpec.describe AutoCheckoutTicketJob do
  context 'not checked out ticket is updated' do
    let(:ticket) { FactoryBot.create(:ticket, left_at: nil) }

    it 'sets left_at of the ticket' do
      expect { described_class.perform_now(ticket.id) }.to change { ticket.reload.left_at }
    end
  end

  context 'checked out ticket is ignored' do
    let(:ticket) { FactoryBot.create(:ticket, left_at: 1.hour.ago) }

    it 'does not change the ticket' do
      expect { described_class.perform_now(ticket.id) }.not_to change { ticket.reload.updated_at } 
    end
  end
end
