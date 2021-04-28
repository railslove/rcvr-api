class DataRequestMailer < ApplicationMailer
  default from: 'recover <info@rcvr.app>'

  def notification_email
    owner = params[:owner]
    @company = params[:company]
    @data_request = params[:data_request]
    mail(to: owner.email, subject: "Dringend: recover-Datenfreigabe für das Gesundheitsamt erforderlich")
  end

end
