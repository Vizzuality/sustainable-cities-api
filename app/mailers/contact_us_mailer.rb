# frozen_string_literal: true
class ContactUsMailer < AsyncMailer
  def contact_us_email(name, email, message)
    @sc_email     = ENV['SC_EMAIL']
    @name = name
    @email = email
    @message = message

    @subject = 'Contact request'

    mail(to: @sc_email, subject: @subject)
  end
end
