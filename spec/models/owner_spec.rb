require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe ".stripe_price_id" do
    let(:owner) { FactoryBot.create(:owner) }
    let(:affiliate) { FactoryBot.create(:affiliate) }

    subject { owner.stripe_price_id }

    it 'Uses the affialiate price' do
      owner.update(affiliate: affiliate.code)

      expect(subject).to eq(affiliate.stripe_price_id_monthly)

    end

    it 'Falls back to the main env price' do
      expect(subject).to eq(ENV['STRIPE_SUBSCRIPTION_PRICE_ID'])
    end

    it 'Complains of the env is missing' do
      ENV['STRIPE_SUBSCRIPTION_PRICE_ID'].tap do |backup|
        ENV['STRIPE_SUBSCRIPTION_PRICE_ID'] = nil

        expect { subject }.to raise_error(StandardError)

        ENV['STRIPE_SUBSCRIPTION_PRICE_ID'] = backup
      end
    end
  end
end
