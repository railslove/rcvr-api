module RailsAdminConfig
  module ForArea
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :name, :id, :company, :tickets

        field :checkin_link do
          read_only true
        end
      end
    end
  end
end
