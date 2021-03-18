class Iris::CompaniesSearch
  include Interactor
  include RequiredAttributes

  required_attributes %i[search_string]

  def call

    context.search_results =
      Company
        .joins(:owner).where("LOWER(companies.name) like LOWER(:search) OR LOWER(owners.company_name) like LOWER(:search)", search: "%#{search_string}%")
        .map do |company|
        {
          id: company.id,
          name: company.name,
          contact: {
            officialName: company.owner.company_name,
            representative: company.owner.name,
            address: {
              street: "",
              city: "",
              zip: ""
            },
            ownerEmail: company.owner.email,
            phone: company.owner.phone
          }
        }
      end

  end

end