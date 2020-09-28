module RailsAdminConfig
  module ForWhitelabel
    extend ActiveSupport::Concern
    included do
      rails_admin do
        fields :name, :intro_text, :privacy_url, :formal_address, :logo, :logo_small_width, :logo_small_height, :logo_big_width, :logo_big_height

        field :background_color, :color
        field :primary_highlight_color, :color
        field :secondary_highlight_color, :color
      end
    end
  end
end
