
require 'rails_helper'

RSpec.describe IrisUpdateCompany, type: :job do

  it "should send a update request via JSON-RPC" do
    company = FactoryBot.create(:company)
    expect_any_instance_of(Jimson::ClientHelper).to receive(:process_call).with(:postLocationsToSearchIndex, {
      locations: [
        {
          id: company.id, 
          name: company.name, 
          contact: {
            officalName: company.name, 
            representative: company.owner.name, 
            address: {
              street: company.street, 
              city: company.city, 
              zip: company.zip
            }, 
            email: company.owner.email,
            phone: company.owner.phone
          }
        }
      ]
    })
    IrisUpdateCompany.perform_now(company.id)
  end
end
