class ApplicationMailer < ActionMailer::Base
  default from: 'recover <info@rcvr.app>'
  layout 'mailer'
end
