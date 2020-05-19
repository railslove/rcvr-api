module RailsAdminConfig
  module ForOwner
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :email, :created_at, :name, :companies, :affiliate
      end
    end
  end
end
