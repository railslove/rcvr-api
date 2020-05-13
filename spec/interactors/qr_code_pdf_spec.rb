require 'rails_helper'

RSpec.describe QrCodePdf do
  let(:area) { FactoryBot.create(:area) }

  subject { -> { described_class.call(area: area) } }

  context 'happy path' do
    it 'Runs without errors' do
      expect(subject.call.success?).to be(true)
    end

    it 'Sets a proper qr code url' do
      url = subject.call.data[:qrcode]
      query = Rack::Utils.parse_nested_query(url.query)

      expect(query['a']).not_to be(nil)
      expect(query['k']).not_to be(nil)
    end
  end

  context 'Owner has no public key' do
    before { area.company.owner.update(public_key: nil) }

    it { is_expected.to raise_error(StandardError) }
  end
end
