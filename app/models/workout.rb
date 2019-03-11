#------------------------------------------------------------------------------
# Workout
#
# Name       SQL Type             Null    Primary Default
# ---------- -------------------- ------- ------- ----------
# id         bigint               false   true              
# notes      text                 true    false             
# user_id    integer              false   false             
# routine_id integer              false   false             
# active     boolean              false   false   false     
# created_at timestamp without time zone false   false             
# updated_at timestamp without time zone false   false             
#
#------------------------------------------------------------------------------

class Workout < ApplicationRecord
  belongs_to :routine
  has_many :setts
  has_many :exercises, through: :setts


  def unique_exercises
    Exercise.find( self.setts.select(:exercise_id).distinct.map{|e|e.exercise_id} )
  end

end

