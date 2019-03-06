# == Schema Information
#
# Table name: routines
#
#  id                   :bigint(8)        not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  name                 :string
#  user_id              :integer
#  description          :text
#  exercise_id          :integer
#  exercise_target_reps :integer
#

class Routine < ApplicationRecord
  has_many :users
  has_many :exercise_routines
  has_many :exercises, through: :exercise_routines
  
  accepts_nested_attributes_for :exercises
  accepts_nested_attributes_for :exercise_routines
  
  
end
