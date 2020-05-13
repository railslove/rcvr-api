require 'rails_helper'

RSpec.describe Owners::TicketsController do
  include_context 'api request authentication'

  let(:area) { FactoryBot.create(:area) }
  let(:path) { owners_company_tickets_path(company_id: area.company.id) }

  before { sign_in(area.company.owner) }

  subject { response }

  context 'GET index' do
    context 'without the proper params' do
      before { get path }

      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    context 'with proper params' do
      let(:time_range) { 2.hours.ago..1.hour.ago }

      let!(:ticket) { FactoryBot.create(:ticket, area: area, entered_at: time_range.begin, left_at: time_range.end) }

      before { get(path, params: { from: time_range.begin.iso8601, to: time_range.end.iso8601 }) }

      it { is_expected.to have_http_status(:ok) }

      it 'containts the ticket' do
        expect(JSON.parse(subject.body).first['id']).to eq(ticket.id)
      end

      it 'containts no encrypted data' do
        expect(JSON.parse(subject.body).first['encrypted_data']).to be_nil
      end
    end
  end
end
