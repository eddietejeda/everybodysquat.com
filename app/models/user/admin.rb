module User::Admin
  extend ActiveSupport::Concern

  def is_admin?
    self.admin
  end
  
  
end




