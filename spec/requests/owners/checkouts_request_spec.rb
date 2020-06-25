require 'rails_helper'

RSpec.describe Owners::AreasController do
  include_context 'api request authentication'

  before { allow(Stripe::Subscription).to receive(:update) }
  before { allow(Stripe::Checkout::Session).to receive(:create) }
  before { allow(Stripe::Subscription).to receive(:retrieve).and_return(double(status: :active)) }

  before { sign_in(owner) }

  context 'creating billing things' do
    let(:owner) { FactoryBot.create(:owner) }

    before { post owners_checkout_path }

    subject { response }

    it { is_expected.to have_http_status(:success) }

    context 'no trial_ends_at' do
      let(:owner) { FactoryBot.create(:owner, trial_ends_at: nil) }

      subject { Stripe::Checkout::Session }

      it { is_expected.to have_received(:create).with(hash_including(subscription_data: hash_including(trial_end: nil) )) }
    end

    context 'trial expired' do
      let(:owner) { FactoryBot.create(:owner, trial_ends_at: 1.day.ago) }

      subject { Stripe::Checkout::Session }

      it { is_expected.to have_received(:create).with(hash_including(subscription_data: hash_including(trial_end: nil) )) }
    end

    context 'normal trial' do
      let(:trial_end) { 4.days.from_now }
      let(:owner) { FactoryBot.create(:owner, trial_ends_at: trial_end) }

      subject { Stripe::Checkout::Session }

      it { is_expected.to have_received(:create).with(hash_including(subscription_data: hash_including(trial_end: trial_end.to_i) )) }
    end
  end

  context 'updating billing things' do
    let(:owner) { FactoryBot.create(:owner, stripe_subscription_id: 'sub_1') }

    before { post owners_checkout_path }

    subject { response }

    it { is_expected.to have_http_status(:success) }
  end
end
