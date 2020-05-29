class ApplicationMailer < ActionMailer::Base
  default from: 'recover <info@rcvr.app>'
  layout 'mailer'

  around_action :set_locale

  def set_locale(&action)
    I18n.with_locale(:de, &action)
  end
end
