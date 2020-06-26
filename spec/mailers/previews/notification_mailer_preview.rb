class NotificationMailerPreview < ActionMailer::Preview
  def notification_email
    NotificationMailer.with(
      owner: FactoryBot.build(:owner),
      subject: 'Dieses ist eine Benachrichtigung',
      body: <<-END
        Wir haben tolle Nachrichten für euch! Leider ist alles doof.

        Ansonsten alles beim alten!
      END
    ).notification_email
  end
end
