module RailsAdminConfig
  module ForOwner
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :email, :created_at, :name, :companies, :affiliate, :can_use_for_free, :trial_ends_at

        field :stripe_subscription_status do
          read_only true
        end

        field :stripe_subscription_id do
          read_only true
        end

        field :stripe_customer_id do
          read_only true
        end
      end
    end
  end
end
