module RailsAdminConfig
  module ForAffiliate
    extend ActiveSupport::Concern

    included do

      attr_accessor :remove_logo
      after_save { logo.purge if remove_logo == '1' }

      rails_admin do
        fields :name, :code
        field :owner_count do
          label "Owners"
          formatted_value do
            path = bindings[:view].index_path(model_name: 'Owner')
            bindings[:view].link_to(bindings[:object].owner_count, "#{path}?f[affiliate][1][o]=is&f[affiliate][1][v]=#{ERB::Util.url_encode(bindings[:object].code)}")
          end
        end
        field :companies_count do
          label "Companies"
          formatted_value do
            bindings[:object].company_count
          end
          read_only true
        end
        fields :stripe_price_id_monthly, :custom_trial_phase, :logo_link


        field :custom_trial_phase do
          help "Must be a proper ISO 8601 duration (https://www.digi.com/resources/documentation/digidocs/90001437-13/reference/r_iso_8601_duration_format.htm)"
        end

        field :logo, :active_storage

        field :link do
          read_only true
        end
      end
    end
  end
end
