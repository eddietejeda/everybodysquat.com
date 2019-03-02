# == Schema Information
#
# Table name: exercise_routines
#
#  exercise_id :bigint(8)
#  routine_id  :bigint(8)
#  sets        :integer
#  reps        :integer
#

class ExerciseRoutine < ApplicationRecord
  belongs_to :exercise
  belongs_to :routine
end
