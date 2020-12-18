module RailsAdminConfig
  module ForArea
    extend ActiveSupport::Concern

    included do
      rails_admin do
        configure :checkin_link do
        end
        fields :name, :id, :company, :tickets, :checkin_link
      end
    end
  end
end
