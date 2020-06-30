module RailsAdminConfig
  module ForFrontend
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :name, :url, :owners
      end
    end
  end
end
