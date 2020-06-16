module RailsAdminConfig
  module ForAffiliate
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :name, :code, :stripe_price_id_monthly

        field :link do
          read_only true
        end
      end
    end
  end
end
