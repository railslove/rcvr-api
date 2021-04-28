require 'rails_helper'

RSpec.describe DataRequest do
  describe "#unaccepted" do

    it "returns a list of unaccepted data requests" do
      data_request = FactoryBot.create(:data_request)
      FactoryBot.create(:data_request, accepted_at: Time.zone.now) 

      expect(DataRequest.unaccepted).to eq([data_request])
    end

  end

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

    it "only returns tickets from the correct timestamp" do
      FactoryBot.create(:ticket, company: data_request.company,
                                 entered_at: data_request.from - 5.minutes,
                                 left_at: data_request.from - 1.minute)
      FactoryBot.create(:ticket, company: data_request.company,
                                 entered_at: data_request.to + 1.minute,
                                 left_at: data_request.to + 5.minute)
      expect(data_request.tickets).to eq([ticket])
    end

  end
end
