module RailsAdminConfig
  module ForArea
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :name, :id, :company, :tickets
      end
    end
  end
end
