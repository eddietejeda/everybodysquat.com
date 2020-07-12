module User::Notifications
  
  extend ActiveSupport::Concern
  
  def send_admin_mail
    UserMailer.new_user_waiting_for_approval(email).deliver
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end
  #
  # def login
  #   @login || self.username || self.email
  # end
  #
end