require 'rails_helper'

RSpec.describe QrCode do
  let(:area) { FactoryBot.create(:area) }

  context 'happy path pdf' do
    subject { -> { described_class.call(area: area, format: 'pdf') } }

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

  context 'happy path png' do
    subject { -> { described_class.call(area: area, format: 'png') } }

    it 'Runs without errors' do
      expect(subject.call.success?).to be(true)
      expect(subject.call.data).not_to be(nil)
    end
  end

  context 'happy path svg' do
    subject { -> { described_class.call(area: area, format: 'svg') } }

    it 'Runs without errors' do
      expect(subject.call.success?).to be(true)
      expect(subject.call.data).not_to be(nil)
    end
  end

  context 'invalid format' do
    subject { -> { described_class.call(area: area, format: 'xyz') } }

    it { is_expected.to raise_error(StandardError) }
  end

  context 'Owner has no public key' do
    subject { -> { described_class.call(area: area, format: 'pdf') } }

    before { area.company.owner.update(public_key: nil) }

    it { is_expected.to raise_error(StandardError) }
  end
end
