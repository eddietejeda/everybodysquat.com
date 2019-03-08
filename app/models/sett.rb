#------------------------------------------------------------------------------
# Sett
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             bigint               false   true              
# set_completed  boolean              false   false   false     
# set_goal       integer              false   false             
# reps_completed integer              false   false             
# reps_goal      integer              false   false             
# workout_id     integer              false   false             
# exercise_id    integer              false   false             
# weight         integer              false   false   0         
# created_at     timestamp without time zone false   false             
# updated_at     timestamp without time zone false   false             
#
#------------------------------------------------------------------------------


class Sett < ApplicationRecord
  has_one :workout
  belongs_to :exercise
  
  
  def set_completed?
    !self.where(exercise_id: self.exercise_id, workout_id: self.workout_id, set_completed: false)

  end
  
  def incremented_weight

    if(self.set_completed)
      self.weight + ExerciseRoutine.where(exercise_id: exercise_id).first.try(:increment_by).to_i
    else
      self.weight
    end
  end
  
end

