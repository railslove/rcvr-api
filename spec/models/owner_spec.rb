require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe ".stripe_price_id" do
    let(:owner) { FactoryBot.create(:owner) }
    let(:affiliate) { FactoryBot.create(:affiliate) }

    subject { owner.stripe_price_id }

    it 'Uses the affialiate price' do
      owner.update(affiliate: affiliate.code)

      ENV['STRIPE_SUBSCRIPTION_PRICE_ID'] = 'fallback'

      expect(subject).to eq(affiliate.stripe_price_id_monthly)

    end

    it 'Falls back to the main env price' do
      ENV['STRIPE_SUBSCRIPTION_PRICE_ID'] = 'fallback'

      expect(subject).to eq('fallback')
    end

    it 'Complains of the env is missing' do
      ENV['STRIPE_SUBSCRIPTION_PRICE_ID'] = nil

      expect { subject }.to raise_error(StandardError)
    end
  end
end
