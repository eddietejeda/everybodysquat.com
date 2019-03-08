#------------------------------------------------------------------------------
# Exercise
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         bigint               false   true              
# name       character varying    false   false             
# created_at timestamp without time zone false   false             
# updated_at timestamp without time zone false   false             
#
#------------------------------------------------------------------------------

class Exercise < ApplicationRecord
  has_many :exercise_routines
  has_many :routines, through: :exercise_routines
  has_many :setts
  
  # belongs_to :routine

end
