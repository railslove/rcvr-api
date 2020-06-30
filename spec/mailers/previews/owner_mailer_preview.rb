# http://localhost:3000/rails/mailers/owner_mailer
class OwnerMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(Owner.first, "faketoken")
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(Owner.first, "faketoken")
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(Owner.first, "faketoken")
  end

  def email_changed
    Devise::Mailer.email_changed(Owner.first)
  end

  def password_change
    Devise::Mailer.password_change(Owner.first)
  end
end
