class RailsAdminController < ActionController::Base
  include AbstractController::Helpers
  include ActionController::Flash
  include ActionController::RequestForgeryProtection
  include ActionController::MimeResponds
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionView::Layouts

  around_action :set_locale

  def set_locale(&action)
    I18n.with_locale(:en, &action)
  end
end
