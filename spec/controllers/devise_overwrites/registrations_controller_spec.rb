require "rails_helper"

# we are diffing times here. allow some deviation between controller action and comparison
MAX_SECOND_TIME_DIFF = 5

module DeviseOverwrites
  RSpec.describe RegistrationsController, type: :controller do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:owner]
      @frontend = create(:frontend)
      @twoweeks = ActiveSupport::Duration.parse("P2W")
      @twomonths = ActiveSupport::Duration.parse("P2M")
    end

    before :all do
      @frontend = create(:frontend)
      @affiliate_without_custom_trial = create(:affiliate)
      @affiliate_with_1month_trial = create(:affiliate, { :custom_trial_phase => "P2M" })
      @affiliate_with_broken_trial = create(:affiliate, { :custom_trial_phase => "der hund" })
    end

    describe "POST #create" do
      let(:post_params) { attributes_for(:owner) }
      it "should creates a simple owner" do
        post :create,
             params: {
               :owner => post_params,
               :frontend => {
                 :url => @frontend.url,
               },
             }
        expect(response).to have_http_status(:ok)
      end

      it "should create an owner with 2 weeks trial by default" do
        post :create,
             params: {
               :owner => post_params,
               :frontend => {
                 :url => @frontend.url,
               },
             }
        expect(response).to have_http_status(:ok)
        owner = JSON.parse(response.body)
        trial_end = DateTime.iso8601(owner["trial_ends_at"])
        expected_trial_end = @twoweeks.since

        expect((@twoweeks.since - trial_end).abs().seconds).to be < MAX_SECOND_TIME_DIFF
      end

      it "should set the blocked date to 2 weeks + 2 days by default" do
        post :create,
             params: {
               :owner => post_params,
               :frontend => {
                 :url => @frontend.url,
               },
             }
        owner = JSON.parse(response.body)
        block_at = DateTime.iso8601(owner["block_at"])

        expect((@twoweeks.since + 2.days - block_at).abs().seconds).to be < MAX_SECOND_TIME_DIFF
      end

      it "should fallback to the default 2 week trial period if affiliate doesn't have a special trial phase" do
        post :create,
          params: {
            :owner => post_params,
            :frontend => {
              :url => @frontend.url,
              :affiliate => @affiliate_without_custom_trial.code,
            },
          }
        expect(response).to have_http_status(:ok)
        owner = JSON.parse(response.body)
        trial_end = DateTime.iso8601(owner["trial_ends_at"])

        expect((@twoweeks.since - trial_end).abs().seconds).to be < MAX_SECOND_TIME_DIFF
      end

      it "should use the special trial phase of the affiliate if it exists" do
        post :create,
             params: {
               :owner => post_params.merge({
                 :affiliate => @affiliate_with_1month_trial.code,
               }),
               :frontend => {
                 :url => @frontend.url, :affiliate => @affiliate_with_1month_trial.code,
               },
             }
        expect(response).to have_http_status(:ok)
        owner = JSON.parse(response.body)
        trial_end = DateTime.iso8601(owner["trial_ends_at"])

        expect((@twomonths.since - trial_end).abs().seconds).to be < MAX_SECOND_TIME_DIFF
      end

      it "should block 2 days after the trial period ends when having a custom trial phase" do
        post :create,
             params: {
               :owner => post_params.merge({
                 :affiliate => @affiliate_with_1month_trial.code,
               }),
               :frontend => {
                 :url => @frontend.url,
                 :affiliate => @affiliate_with_1month_trial.code,
               },
             }
        expect(response).to have_http_status(:ok)
        owner = JSON.parse(response.body)
        block_at = DateTime.iso8601(owner["block_at"])

        expect((@twomonths.since + 2.days - block_at).abs().seconds).to be < MAX_SECOND_TIME_DIFF
      end

      it "should ignore unknown affiliates and register anyway using the default trial time" do
        post :create,
             params: {
               :owner => post_params.merge({
                 :affiliate => "schnischnaschnappi",
               }), :frontend => {
                 :url => @frontend.url,
                 :affiliate => @affiliate_with_1month_trial.code,
               },
             }
        expect(response).to have_http_status(:ok)
        owner = JSON.parse(response.body)
        trial_end = DateTime.iso8601(owner["trial_ends_at"])

        expect((@twoweeks.since - trial_end).abs().seconds).to be < MAX_SECOND_TIME_DIFF
      end

      it "should fail hard if an affiliate has an invalid configuration" do
        expect {
          post :create,
               params: {
                 :owner => post_params.merge({
                   :affiliate => @affiliate_with_broken_trial.code,
                 }),
                 :frontend => {
                   :url => @frontend.url,
                   :affiliate => @affiliate_with_1month_trial.code,
                 },
               }
        }.to raise_error(ActiveSupport::Duration::ISO8601Parser::ParsingError)
      end
    end
  end
end
