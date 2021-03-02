module RailsAdminConfig
  module ForCompany
    extend ActiveSupport::Concern

    included do
      attr_accessor :remove_menu_pdf
      after_save { menu_pdf.purge if remove_menu_pdf.present? }

      rails_admin do
        fields :id, :name, :created_at, :areas, :owner, :tickets, :menu_link, :menu_pdf, :is_free, :privacy_policy_link

        field :ticket_count do
          read_only true
        end
        field :open_ticket_count do
          read_only true
        end

        field :stats_url do
          read_only true
        end

      end
    end
  end
end
