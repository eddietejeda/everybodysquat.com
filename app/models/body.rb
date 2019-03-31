class Body < ApplicationRecord
end

#------------------------------------------------------------------------------
# Body
#
# Name           SQL Type             Null    Primary Default
# -------------- -------------------- ------- ------- ----------
# id             bigint               false   true              
# user_id        integer              true    false   0         
# weight         integer              true    false   0         
# fat_percent    integer              true    false   0         
# muscle_percent integer              true    false   0         
# water_percent  integer              true    false   0         
# created_at     timestamp without time zone false   false             
# updated_at     timestamp without time zone false   false             
#
#------------------------------------------------------------------------------
