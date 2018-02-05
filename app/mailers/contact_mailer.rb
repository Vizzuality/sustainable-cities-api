# frozen_string_literal: true
class ContactMailer < AsyncMailer
  def contact_email(user_email)
    @email     = user_email

    @subject = 'Requested link to contact'

    mail(to: @email, subject: @subject)
  end
end
