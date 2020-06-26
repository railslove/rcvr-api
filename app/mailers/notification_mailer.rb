class NotificationMailer < ApplicationMailer
  default from: 'recover <info@rcvr.app>'

  def notification_email
    owner = params[:owner]
    @body = params[:body]

    mail(to: owner.email, subject: params[:subject])
  end
end
