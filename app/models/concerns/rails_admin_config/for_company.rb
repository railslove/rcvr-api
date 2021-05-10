module RailsAdminConfig
  module ForCompany
    extend ActiveSupport::Concern

    included do
    attr_accessor :remove_menu_pdf
      after_save { menu_pdf.purge if remove_menu_pdf.present? }

      rails_admin do
        fields :id, :name, :created_at, :areas, :street, :zip, :city, :owner
        
        field :location_type, :enum do
          enum do
            Company::LOCATION_TYPES.keys.map do |c|
              [Company::LOCATION_TYPES[c], c]
            end
          end
        end

        fields :tickets, :menu_link, :menu_pdf, :is_free, :privacy_policy_link, :need_to_show_corona_test

        field :cwa_link_enabled do
          label "Enable CWA Link after checkin"
        end

        field :ticket_count do
          read_only true
        end
        field :open_ticket_count do
          read_only true
        end
        field :stats_url do
          read_only true
        end

        field :cwa_url do
          label "CWA URL"
          read_only true
        end


      end
    end
  end
end
