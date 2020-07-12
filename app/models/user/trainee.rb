module User::Trainee

  extend ActiveSupport::Concern

  def is_trainee?
    !self.coach
  end



end





