class IrisDeleteCompany < ApplicationJob
  queue_as :default

  def perform(company_id)
    return if ENV["IRIS_EPS_URL"].blank? || ENV["IRIS_LOCATION_IDENTIFIER"].blank?
    Jimson::Client.new(
      ENV["IRIS_EPS_URL"], {id_type: :string}, ENV["IRIS_LOCATION_IDENTIFIER"], {verify_ssl: false}
    ).deleteLocationFromSearchIndex({
      locationId: company_id
    })
  end
end
