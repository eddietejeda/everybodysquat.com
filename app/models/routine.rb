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
  
  
end

