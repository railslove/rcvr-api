# This is a virtual model that is only used in the admin interface.
class AffiliateCompany < Company 

  delegate :trial_ends_at, to: :owner

  rails_admin do
    label "Affiliate Company" 
    label_plural "Affiliate Companies"

    visible false

    field :id do
      formatted_value do
        bindings[:view].link_to(
          value,
          bindings[:view].show_path(model_name: 'Company', id: value)
        )
      end
    end
    field :name
    field :created_at
    field :owner
    field :trial_ends_at, :datetime

    field :affiliate do
      label "Affiliate Code"
      searchable [{:owners => :affiliate}]
      filterable true
    end

    fields :street, :zip, :city

    list do
    end
  end
end
