module User::Settings
  
  extend ActiveSupport::Concern  
  
  def bar_weight
    # this should be stored in a setting somewhere
    return 45
  end
  
  def settings(keyname)
    
    default = {}
    default["rest_time"] = (60*3) # minutes
    default["bar_weight"] = 45
    
    return self.details.to_h[keyname] if self.details.to_h[keyname]
    return default.to_h[keyname] if default.to_h[keyname]
    return nil
  end
  
  
  
  def generate_milestones
    
    timeline = {}
    
  end
  
  
  def set_default_user_settings
    self.routine = Routine.first
    self.details = {"body_weight"=>"", "equipment_bar"=>"45", "equipment_type"=>"barbell", "equipment_plates"=>"45"}
    self.save!
  end
  

  
  
end