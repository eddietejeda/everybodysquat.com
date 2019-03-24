#------------------------------------------------------------------------------
# Routine
#
# Name        SQL Type             Null    Primary Default
# ----------- -------------------- ------- ------- ----------
# id          bigint               false   true              
# name        character varying    false   false             
# description text                 false   false             
# created_at  timestamp without time zone false   false             
# updated_at  timestamp without time zone false   false             
#
#------------------------------------------------------------------------------


class Routine < ApplicationRecord
  has_many :users
  has_many :templates
  has_many :exercises, through: :templates
  
  accepts_nested_attributes_for :exercises
  accepts_nested_attributes_for :templates
  
  
  def distinct_exercises
    self.exercises.distinct
  end
  
  def increment_weight(weight, exercise_id, exercise_group, set_number)
    template = current_user.routine.templates.where(exercise_id: exercise_id, exercise_group: exercise_group).first
    
    new_weight = weight
    if template.workout_progression == 'linear'
      if template.set_progression == 'fixed'
        new_weight = weight + template.incremention_scheme.fetch(set_number).to_i
      else
        Rails.logger.error{"Set progression scheme does not exist"}
      end
    else
      Rails.logger.error{"Workout progression scheme does not exist"}      
    end
    
    new_weight
  end
  
  
end

