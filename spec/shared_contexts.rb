  RSpec.shared_context "api request authentication" do
    before(:each) do
      Warden.test_mode!
    end

    after(:each) do
      Warden.test_reset!
    end

    def sign_in(owner)
      login_as(owner, scope: :owner)
    end

    def sign_out
      logout(:owner)
    end
  end
