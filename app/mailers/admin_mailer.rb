require 'etc'

class AdminMailer < ApplicationMailer
  default from: 'no-reply@everybodysquat.com'
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    to_email = ENV.fetch('ADMIN') || "#{Etc.getlogin}@localhost"
    mail(to: to_email, subject: 'New user awaiting approval')
  end
end