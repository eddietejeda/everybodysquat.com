#------------------------------------------------------------------------------
# Workout
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             bigint               false   true              
# user_id        integer              false   false             
# routine_id     integer              false   false             
# active         boolean              false   false   false     
# exercise_group character varying    false   false             
# notes          text                 true    false             
# created_at     timestamp without time zone false   false             
# updated_at     timestamp without time zone false   false             
# completed_at   timestamp without time zone true    false             
# results        jsonb                true    false             
# began_at       timestamp without time zone true    false             
#
#------------------------------------------------------------------------------

class Workout < ApplicationRecord
  belongs_to :routine
  has_many :setts
  has_many :exercises, through: :setts

  belongs_to :user, required: false


  def distinct_exercises
    Exercise.find( self.setts.select(:exercise_id).distinct.map{|e|e.exercise_id} )
  end


  def current_exercise_weight(exercise_id)
    # self.previous_exercise_setts(exercise_id).max_by(&:weight).try(:weight).to_i
    self.setts.where("exercise_id = :exercise_id", { exercise_id: exercise_id }).max_by(&:weight).try(:weight).to_i
  end
  
  def formated_date
    self.began_at.strftime("%A, %b %d %Y")
  end
  
  def current_results(exercise_id)
    self.results.find{|e|e["exercise_id"] == exercise_id}.to_h["weight"]    
  end
  
  
  # Useful to clearing all the default values with new structure.
  def self.regenerate_all_workout_results
    Workout.all.each do |workout|
      CompleteUserWorkout.new(User.find(workout.user_id)).call(workout)
    end
  end
  
  # Spaces out all the workouts by one day. Useful for testing lots of data.
  def self.space_workout_dates    
    length = Workout.all.count
    Workout.all.each do |workout|
      workout.began_at = length.days.ago
      workout.save!
      length = length - 1
    end
  end
  

end

