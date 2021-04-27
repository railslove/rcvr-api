require 'rails_helper'

RSpec.describe CreateDataRequest do
  let!(:company) { FactoryBot.create(:company) }

  context 'happy path pdf' do
    let(:from) { Time.now - 2.hours }
    let(:to) { Time.now - 1.hour }

    it "creates the data request" do
      subject = CreateDataRequest.call(company: company, reason: "Covid case", from: from, to: to)
      expect(subject.success?).to be(true)

      data_request = subject.data_request
      expect(data_request.accepted_at).to be_nil
      expect(data_request.reason).to eq("Covid case")
      expect(data_request.from).to eq(from)
      expect(data_request.to).to eq(to)
    end

    it "sends an email to the owner" do
      assert_emails 1 do
        CreateDataRequest.call(company: company, reason: "Covid case", from: from, to: to)
      end
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to eq [company.owner.email]
      expect(last_email.subject).to eq('Dringend: recover-Datenfreigabe für das Gesundheitsamt erforderlich')
    end
  end
end