module User::Coach
  extend ActiveSupport::Concern
  
  def is_coach?
    self.coach
  end
  
  
  
end