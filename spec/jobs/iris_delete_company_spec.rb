require 'rails_helper'

RSpec.describe IrisDeleteCompany, type: :job do

  it "should send a delete request via JSON-RPC" do
    company = FactoryBot.create(:company)
    expect_any_instance_of(Jimson::ClientHelper).to receive(:process_call).with(:deleteLocationFromSearchIndex, {
      locationId: company.id
    })
    IrisDeleteCompany.perform_now(company.id)
  end
end
