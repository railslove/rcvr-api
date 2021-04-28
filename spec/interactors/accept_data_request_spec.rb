require 'rails_helper'

RSpec.describe AcceptDataRequest do
  let(:data_request) { FactoryBot.create(:data_request) }

  context 'happy path' do
    subject { -> { described_class.call(data_request: data_request) } }

    it 'Runs without errors' do
      expect(subject.call.success?).to be(true)
    end

    it "accepts the data request" do
      data_request = subject.call.data_request
      expect(data_request).to_not be_nil
    end
  end
end