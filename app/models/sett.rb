#------------------------------------------------------------------------------
# Sett
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             bigint               false   true              
# set_goal       integer              false   false             
# reps_completed integer              false   false             
# reps_goal      integer              false   false             
# workout_id     integer              false   false             
# exercise_id    integer              false   false             
# weight         integer              false   false   0         
# created_at     timestamp without time zone false   false             
# updated_at     timestamp without time zone false   false             
# user_id        integer              false   false   0         
#
#------------------------------------------------------------------------------


class Sett < ApplicationRecord
  has_one :workout
  belongs_to :exercise
  
  
  def set_completed?
    self.set_completed
  end


  def previous_session
    id = Sett.select(:workout_id).where(user_id: self.user_id, exercise_id: self.exercise_id).distinct(:workout_id).order(workout_id: :asc).limit(2).first.try(:workout_id)
    
    Workout.find(id)
  end
  

  def previous_weight
    previous_session.try(:weight).to_i
  end
  
  def previous_set(sett_id)
    Sett.find(sett_id)
  end
  


  # This is not used
  def current_weight(sett_id)    
    if(previous_set(sett_id).reps_completed == previous_set(sett_id).reps_goal)
      previous_weight + Template.where(exercise_id: exercise_id).first.try(:increment_by).to_i
    else
      previous_weight
    end
  end
  
end

