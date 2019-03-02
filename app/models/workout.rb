# == Schema Information
#
# Table name: workouts
#
#  id          :bigint(8)        not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  user_id     :integer
#  exercise_id :integer
#  routine_id  :integer
#

class Workout < ApplicationRecord
  has_many :exercises, through: :setts
  belongs_to :routine
  belongs_to :user
  has_many :setts


  def exercises
    Exercise.find( self.setts.select(:exercise_id).distinct.map{|e|e.exercise_id} )
  end
  
  

  
  
end
