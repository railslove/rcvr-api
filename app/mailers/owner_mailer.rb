class OwnerMailer < Devise::Mailer

  default template_path: 'devise/mailer'
  default from: 'recover <info@rcvr.app>'
end
