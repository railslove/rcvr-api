require 'rails_helper'

RSpec.describe StripeWebhookHandler do
  before { allow(Stripe::Subscription).to receive(:update) }
  before { allow(Stripe::Subscription).to receive(:retrieve).and_return(double(status: :active, pause_collection: nil)) }

  context 'checkout.session.completed' do
    let(:owner) { FactoryBot.create(:owner, block_at: 1.day.from_now) }
    let(:address) { { city: 'Berlin' } }
    let(:billing_details) { OpenStruct.new(address: address) }
    let(:payment_method) { OpenStruct.new(billing_details: billing_details) }
    let(:invoice_settings) { { default_payment_method: payment_method } }

    context "Customer Created" do
      let(:subscription) { OpenStruct.new(default_payment_method: 1) }
      let(:event) do
        OpenStruct.new(
          type: 'checkout.session.completed',
          data: OpenStruct.new(
            object: OpenStruct.new(
              mode: 'subscription',
              customer: 'cus_1',
              subscription: 'sub_1',
              client_reference_id: owner.id
            )
          )
        )
      end

      before do
        allow(Stripe::Subscription).to receive(:retrieve).with('sub_1').and_return(subscription)
        allow(Stripe::PaymentMethod).to receive(:retrieve).and_return(payment_method)
      end

      it 'happy path' do
        expect(Stripe::Customer)
          .to(receive(:update).with('cus_1', invoice_settings: invoice_settings, address: address))
        
        StripeWebhookHandler.call(event: event)

        expect(owner.reload.stripe_customer_id).to eq('cus_1')
        expect(owner.reload.stripe_subscription_id).to eq('sub_1')
        expect(owner.reload.block_at).to eq(nil)
      end
    end

    context 'Customer Billing Update' do
      let(:setup_intent) { OpenStruct.new(payment_method: 'pm_1') }
      let(:event) do
        OpenStruct.new(
          type: 'checkout.session.completed',
          data: OpenStruct.new(
            object: OpenStruct.new(
              mode: 'setup_intent',
              customer: 'cus_1',
              subscription: 'sub_1',
              client_reference_id: owner.id,
              setup_intent: 'si_1'
            )
          )
        )
      end

      before do
        allow(Stripe::SetupIntent).to receive(:retrieve).with('si_1').and_return(setup_intent)
        allow(Stripe::PaymentMethod).to receive(:retrieve).and_return(payment_method)
      end

      it 'happy path' do
        expect(Stripe::Customer)
          .to(receive(:update).with('cus_1', invoice_settings: invoice_settings, address: address))
        
        StripeWebhookHandler.call(event: event)

        expect(owner.reload.stripe_customer_id).to eq('cus_1')
        expect(owner.reload.stripe_subscription_id).to eq('sub_1')
        expect(owner.reload.block_at).to eq(nil)
      end
    end
  end

  context 'customer.subscription.updated' do
    let(:owner) { FactoryBot.create(:owner, stripe_subscription_id: 'sub_1') }

    let(:event) do
      OpenStruct.new(
        type: 'customer.subscription.updated',
        data: OpenStruct.new(
          object: OpenStruct.new(
            id: owner.stripe_subscription_id,
            cancel_at: cancel_at&.to_i
          )
        )
      )
    end

    before { StripeWebhookHandler.call(event: event) }
    subject { owner.reload.block_at }

    context 'canceled' do
      let(:cancel_at) { 1.day.from_now }

      it { is_expected.to be_within(1.second).of(cancel_at) }
    end

    context 'not canceled' do
      let(:cancel_at) { nil }

      it { is_expected.to be(cancel_at) }
    end
  end
end
