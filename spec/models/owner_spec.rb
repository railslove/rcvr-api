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

  describe '.auto_checkout_time' do
    let(:owner) { FactoryBot.create(:owner) }

    subject { owner.auto_checkout_time }

    it 'returns the default time' do
      expect(subject).to eq(4.hours)
    end
    it 'returns the custom time' do
      owner.update(auto_checkout_minutes: 120)
      expect(subject).to eq(2.hours)
    end
  end

  describe '.update' do
    before { allow(Stripe::Subscription).to receive(:update) }
    let(:owner) { FactoryBot.create(:owner, stripe_subscription_id: 'sub_1') }

    it "does updates stripe if payment is configured" do
      allow(Stripe::Subscription).to receive(:retrieve).and_return(
        double(status: :active, pause_collection: nil)
      )
      owner.update!(name: "Exampe Pub")
      expect(Stripe::Subscription).to have_received(:update).at_least(:once)
    end

    it "does not update stripe if payment paused" do
      allow(Stripe::Subscription).to receive(:retrieve).and_return(
        double(status: :active, pause_collection: {
          pause_collection: {
            behavior: "mark_uncollectible", resumes_at: nil
          }
        })
      )
      owner.update!(name: "Exampe Pub")
      expect(Stripe::Subscription).not_to have_received(:update)
    end

  end
end
