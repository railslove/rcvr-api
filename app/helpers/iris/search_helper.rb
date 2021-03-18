module Iris::SearchHelper

  def search_for_locations (search_string)
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
