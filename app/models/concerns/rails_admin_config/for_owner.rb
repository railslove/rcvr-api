module RailsAdminConfig
  module ForOwner
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :id, :email, :created_at, :name, :companies, :affiliate, :can_use_for_free, :trial_ends_at,
               :block_at, :frontend, :stripe_subscription_id, :stripe_customer_id, :menu_alias

        field :stripe_subscription_status do
          read_only true
        end

        field :auto_checkout_minutes do
          help "Default is #{::Ticket::AUTO_CHECKOUT_AFTER.to_i / 60} minutes if not specified"
        end

        field :api_token do
          read_only true
        end

        list do
          scopes [:all, :affiliate, :with_stripe_data]
        end
      end
    end
  end
end
