class AddBeganAtToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :began_at,    :datetime
    
  end
end
