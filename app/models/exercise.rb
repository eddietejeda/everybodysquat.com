# == Schema Information
#
# Table name: exercises
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#

class Exercise < ApplicationRecord
  has_many :exercise_routines
  has_many :routines, through: :exercise_routines
  has_many :setts
end
