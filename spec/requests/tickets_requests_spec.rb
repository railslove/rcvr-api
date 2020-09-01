require 'rails_helper'

RSpec.describe TicketsController do
  context 'POST create' do
    let!(:area) { FactoryBot.create(:area) }
    let(:ticket_attributes) { FactoryBot.attributes_for(:ticket, :open, area_id: area.id) }

    subject { -> { post tickets_path, params: { ticket: ticket_attributes } } }

    it { is_expected.to change(Ticket, :count).by(1) }

    it 'Has the right status and content' do
      subject.call

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end

    # Using 1 second tolerence as noted in https://github.com/rspec/rspec-rails/issues/2333#issuecomment-628790743
    # Alternative: user Timecop
    it { is_expected.to have_enqueued_job(AutoCheckoutTicketJob).at(a_value_within(1.seconds).of(4.hours.from_now)) }

    it 'uses auto_checkout_minutes from owner' do
      area.company.owner.update_attribute(:auto_checkout_minutes, 720)
      is_expected.to have_enqueued_job(AutoCheckoutTicketJob).at(a_value_within(1.seconds).of(12.hours.from_now))
    end
  end

  context 'PATCH update' do
    let(:open_ticket) { FactoryBot.create(:ticket, :open) }
    let(:closed_ticket) { FactoryBot.create(:ticket) }
    let(:left_at) { Time.zone.now }

    it 'updates an existing ticket' do
      patch ticket_path(open_ticket), params: { id: open_ticket.id, ticket: { left_at: left_at } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
      expect(open_ticket.reload.left_at.iso8601).to eql(left_at.iso8601)
    end

    it 'does not update closed tickets' do
      patch ticket_path(closed_ticket), params: { id: closed_ticket.id, ticket: { left_at: left_at } }
      orig_left_at = closed_ticket.left_at

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
      expect(closed_ticket.reload.left_at.iso8601).to eql(orig_left_at.iso8601)
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
