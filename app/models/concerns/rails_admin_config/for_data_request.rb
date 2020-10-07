module RailsAdminConfig
  module ForDataRequest
    extend ActiveSupport::Concern

    included do
      rails_admin do
        fields :company, :from, :to, :reason

        fields :accepted_at, :tickets do
          read_only true
        end
      end
    end
  end
end
