#------------------------------------------------------------------------------
# Workout
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         bigint               false   true              
# notes      text                 true    false             
# user_id    integer              false   false             
# routine_id integer              false   false             
# active     boolean              false   false   false     
# created_at timestamp without time zone false   false             
# updated_at timestamp without time zone false   false             
#
#------------------------------------------------------------------------------

class Workout < ApplicationRecord
  belongs_to :routine
  has_many :setts
  has_many :exercises, through: :setts


  def distinct_exercises
    Exercise.find( self.setts.select(:exercise_id).distinct.map{|e|e.exercise_id} )
  end


  def current_exercise_weight(exercise_id)
    # self.previous_exercise_setts(exercise_id).max_by(&:weight).try(:weight).to_i
    self.setts.where("exercise_id = :exercise_id", { exercise_id: exercise_id }).max_by(&:weight).try(:weight).to_i
  end
  
  def formated_date
    self.created_at.strftime("%A, %b %d %Y")
  end
  
  def current_training_max(exercise_id)
    self.training_maxes.find{|e|e["exercise_id"] == exercise_id}.to_h["weight"]    
  end

end

