require 'rails_helper'

MAX_SECOND_TIME_DIFF = 5.seconds

RSpec.describe 'POST /signup', type: :request do
  let(:url) { '/signup' }
  let(:frontend) { FactoryBot.create(:frontend) }
  let(:params) do
    {
      owner: {
        email: 'owner@example.com',
        company_name: 'Railslove',
        phone: '0221666666666',
        password: 'password',
        affiliate: 'AFFNAME'
      },
      frontend: {
        url: frontend.url
      }
    }
  end
  let(:twoweeks) { ActiveSupport::Duration.parse("P2W") }
  let(:twomonths) { ActiveSupport::Duration.parse("P2M") }
  let(:affiliate_without_custom_trial) { FactoryBot.create(:affiliate) }
  let(:affiliate_with_2month_trial) { FactoryBot.create(:affiliate, { :custom_trial_phase => "P2M" }) }

  context 'when owner is unauthenticated' do
    before { post url, params: params }

    it 'returns ok' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('AFFNAME')
    end

    it 'creates a new owner' do
      expect(Owner.count).to eq(1)
    end

    it 'Signs the owner in directly' do
      expect(response.headers['Authorization']).to be_present
    end
  end

  context 'when affiliate is not specified' do
    before { post url, params: params }

    it "should create an owner with 2 weeks trial" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      trial_end = DateTime.iso8601(owner["trial_ends_at"])
      expected_trial_end = twoweeks.since.to_datetime

      expect(trial_end).to be_within(MAX_SECOND_TIME_DIFF).of(expected_trial_end)
    end

    it "should set the blocked date to 2 weeks + 2 days" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      block_at = DateTime.iso8601(owner["block_at"])
      expected_block_at = (twoweeks.since + 2.days).to_datetime

      expect(block_at).to be_within(MAX_SECOND_TIME_DIFF).of(expected_block_at)
    end
  end

  context 'when affiliate does not specify a custom trial phase' do
    let (:affiliate_without_custom_trial_params) {
      params.deep_merge({ owner: { affiliate: affiliate_without_custom_trial.code } })
    }
    before { post url, params: affiliate_without_custom_trial_params }

    it "should create an owner with the default 2 week trial period" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      trial_end = DateTime.iso8601(owner["trial_ends_at"])
      expected_trial_end = twoweeks.since.to_datetime

      expect(trial_end).to be_within(MAX_SECOND_TIME_DIFF).of(expected_trial_end)
    end

    it "should set the blocked date to 2 weeks + 2 days" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      block_at = DateTime.iso8601(owner["block_at"])
      expected_block_at = (twoweeks.since + 2.days).to_datetime

      expect(block_at).to be_within(MAX_SECOND_TIME_DIFF).of(expected_block_at)
    end
  end

  context 'when affiliate specifies a custom trial phase' do
    let (:affiliate_with_2month_trial_params) {
      params.deep_merge({ owner: { affiliate: affiliate_with_2month_trial.code } })
    }
    before { post url, params: affiliate_with_2month_trial_params }

    it "should use the special trial phase of the affiliate" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      trial_end = DateTime.iso8601(owner["trial_ends_at"])
      expected_trial_end = twomonths.since.to_datetime

      expect(trial_end).to be_within(MAX_SECOND_TIME_DIFF).of(expected_trial_end)
    end

    it "should block 2 days after the custom trial period" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      block_at = DateTime.iso8601(owner["block_at"])
      expected_block_at = (twomonths.since + 2.days).to_datetime

      expect(block_at).to be_within(MAX_SECOND_TIME_DIFF).of(expected_block_at)
    end
  end

  context 'when specifiying an unknown affiliate' do
    before { post url, params: params.merge({:frontend => {:affiliate => "schnischnaschnappi"}}) }

    it "should create an owner with the default trial phase time" do
      expect(response).to have_http_status(:ok)
      owner = JSON.parse(response.body)
      trial_end = DateTime.iso8601(owner["trial_ends_at"])
      expected_trial_end = twoweeks.since.to_datetime

      expect(trial_end).to be_within(MAX_SECOND_TIME_DIFF).of(expected_trial_end)
    end
  end
  
  context 'when owner already exists' do
    let!(:owner) { FactoryBot.create(:owner, email: params[:owner][:email]) }

    before { post url, params: params }

    it 'returns unprocessable_entity status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
