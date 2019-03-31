#------------------------------------------------------------------------------
# Template
#
# Name                SQL Type             Null    Primary Default
# ------------------- -------------------- ------- ------- ----------
# id                  bigint               false   true              
# routine_id          integer              false   false             
# exercise_id         integer              false   false             
# exercise_group      character varying    false   false             
# workout_progression character varying    false   false             
# set_progression     character varying    false   false             
# incremention_scheme integer              true    false   {}        
# reps                integer              true    false   {}        
# sets                integer              false   false             
# weight_type         character varying    false   false             
# created_at          timestamp without time zone false   false             
# updated_at          timestamp without time zone false   false             
#
#------------------------------------------------------------------------------


class Template < ApplicationRecord
  belongs_to :exercise
  belongs_to :routine
  
  accepts_nested_attributes_for :exercise
  
end

