class RailsAdminController < ActionController::Base
  include AbstractController::Helpers
  include ActionController::Flash
  include ActionController::RequestForgeryProtection
  include ActionController::MimeResponds
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionView::Layouts

  before_action :set_locale

  def set_locale
    I18n.locale = :en
  end
end
