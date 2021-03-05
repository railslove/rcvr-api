module RailsAdminConfig
  module ForAffiliate
    extend ActiveSupport::Concern

    included do

      attr_accessor :remove_logo
      after_save { logo.purge if remove_logo == '1' }

      rails_admin do
        fields :name, :code, :stripe_price_id_monthly, :custom_trial_phase

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
