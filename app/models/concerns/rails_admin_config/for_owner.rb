module RailsAdminConfig
  module ForOwner
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :email, :created_at, :name, :companies
      end
    end
  end
end
