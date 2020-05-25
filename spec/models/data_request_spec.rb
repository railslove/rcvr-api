require 'rails_helper'

RSpec.describe DataRequest do
  describe "#accept!" do
    let(:data_request) { FactoryBot.create(:data_request) }

    let(:ticket) do
      FactoryBot.create(:ticket, company: data_request.company,
                                 entered_at: data_request.from + 1.minute,
                                 left_at: data_request.to - 1.minute)
    end

    subject { -> { data_request.accept! } }

    it { is_expected.to change { ticket.reload.status }.to('at_risk') }

    it { is_expected.to change { data_request.reload.accepted_at }.from(nil) }
  end
end
