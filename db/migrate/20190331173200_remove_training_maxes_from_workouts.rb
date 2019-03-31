class RemoveTrainingMaxesFromWorkouts < ActiveRecord::Migration[5.2]
  def change
    remove_column :workouts, :training_maxes

  end
end
