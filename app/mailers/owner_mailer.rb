class OwnerMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers

  default template_path: 'devise/mailer'
  default from: 'info@rcvr.app'
end
