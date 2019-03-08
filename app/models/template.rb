#------------------------------------------------------------------------------
# Template
#
# Name                SQL Type             Null    Primary Default
# ------------------- -------------------- ------- ------- ----------
# id                  bigint               false   true              
# routine_id          integer              false   false             
# exercise_id         integer              false   false             
# sets                integer              false   false             
# reps                integer              false   false             
# group               character varying    false   false             
# progression_type    character varying    false   false             
# incremention_scheme integer              true    false   {}        
# created_at          timestamp without time zone false   false             
# updated_at          timestamp without time zone false   false             
#
#------------------------------------------------------------------------------


class Template < ApplicationRecord
  belongs_to :exercise
  belongs_to :routine
  
  accepts_nested_attributes_for :exercise
  
end

