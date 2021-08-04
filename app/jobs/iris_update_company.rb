class IrisUpdateCompany < ApplicationJob
  queue_as :default

  def perform(company_id)
    return if ENV["IRIS_EPS_URL"].blank?

    company = Company.find(company_id)
    return unless company

    Jimson::Client.new(
      ENV["IRIS_EPS_URL"], {id_type: :string}, ENV["IRIS_LOCATION_IDENTIFIER"], {verify_ssl: false}
    ).postLocationsToSearchIndex({
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
  end
end
