module RailsAdminConfig
  module ForTicket
    extend ActiveSupport::Concern

    included do
      rails_admin do
        field :id
        field :area, :string do
          formatted_value do
            bindings[:view].link_to(
              value&.name,
              bindings[:view].show_path(model_name: 'area', id: value&.id)
            )
          end
          export_value do
            value&.name
          end
        end
        field :entered_at
        field :left_at
        field :encrypted_data

        export do
          configure :id do
            hide
          end
        end

        list do
          search_by :by_company
        end
      end
    end
  end
end
