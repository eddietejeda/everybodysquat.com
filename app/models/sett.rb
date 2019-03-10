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
    self.set_completed
  end


  def previous_session
    Sett.where(exercise_id: self.exercise_id).order(:id).last(2).first
  end
  

  def previous_weight
    previous_session.try(:weight).to_i
  end
  
  def current_weight
    if(previous_session.set_completed)
      previous_weight + Template.where(exercise_id: exercise_id).first.try(:increment_by).to_i
    else
      previous_weight
    end
  end
  
end

