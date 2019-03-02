class CreateExerciseRoutine < ActiveRecord::Migration[5.2]
  def change
    create_table :exercise_routines do |t|
      t.integer :routine_id,        null: false
      t.integer :exercise_id,       null: false
      t.integer :sets,              null: false
      t.integer :reps,              null: false
      t.string  :group,             null: false
      t.string  :progression_type,  null: false
      t.integer :increment_by,      null: false
      t.timestamps null: false
    end
  end
end
