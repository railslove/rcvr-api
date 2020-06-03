require 'rails_helper'

RSpec.describe Owners::AreasController do
  include_context 'api request authentication'

  before { allow(Stripe::Subscription).to receive(:update) }
  before { allow(Stripe::Checkout::Session).to receive(:create) }

  before { sign_in(owner) }

  context 'creating billing things' do
    let(:owner) { FactoryBot.create(:owner) }

    before { post owners_checkout_path }

    subject { response }

    it { is_expected.to have_http_status(:success) }
  end

  context 'updating billing things' do
    let(:owner) { FactoryBot.create(:owner, stripe_subscription_id: 'sub_1') }

    before { post owners_checkout_path }

    subject { response }

    it { is_expected.to have_http_status(:success) }
  end
end
