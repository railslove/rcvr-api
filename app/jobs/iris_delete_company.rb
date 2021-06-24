class IrisDeleteCompany < ApplicationJob
  queue_as :default

  def perform(company_id)
    return if ENV["IRIS_EPS_URL"].blank?
    Jimson::Client.new(
      ENV["IRIS_EPS_URL"], {id_type: :string}, "ls-1.", {verify_ssl: false}
    ).deleteLocationFromSearchIndex({
      locationId: company_id
    })
  end
end
