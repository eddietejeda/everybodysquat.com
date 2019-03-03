require 'etc'

class AdminMailer < ApplicationMailer
  default from: 'no-reply@everybodysquat.com'
  layout 'mailer'

  def new_user_waiting_for_approval(email)
    @email = email
    to_email = ENV['ADMIN_EMAIL'] || "#{Etc.getlogin}@localhost"
    logger.debug "Admin email is: #{to_email}"
    mail(to: to_email, subject: 'New user awaiting approval')
  end
end