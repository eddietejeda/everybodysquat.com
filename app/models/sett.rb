# == Schema Information
#
# Table name: worksets
#
#  id             :bigint(8)        not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  set_number     :integer
#  reps_goal      :integer
#  reps_completed :integer
#  workout_id     :integer
#  exercise_id    :integer
#  sets           :integer
#

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
