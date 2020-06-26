class NotificationMailer < ApplicationMailer
  default from: 'recover <info@rcvr.app>'

  def notification_email
    owner = params[:owner]
    @body = params[:body]

    mail(to: owner.email, subject: params[:subject])
  end

  def self.notify_all_owners(params)
    Owner.all.each do |owner|
      NotificationMailer.with(params.merge(owner: owner)).notification_email.deliver_later
    end
  end
end
