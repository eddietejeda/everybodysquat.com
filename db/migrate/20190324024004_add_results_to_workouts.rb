class AddResultsToWorkouts < ActiveRecord::Migration[5.2]
  def change
    add_column :workouts, :results, :jsonb
  end
end
