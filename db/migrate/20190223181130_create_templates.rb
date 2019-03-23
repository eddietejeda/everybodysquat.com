class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.integer :routine_id,          null: false
      t.integer :exercise_id,         null: false
      t.string  :exercise_group,      null: false

      t.string  :workout_progression, null: false
      t.string  :set_progression,     null: false
      t.integer :incremention_scheme, null: true, array: true, default: []

      t.integer :reps,                null: true, array: true, default: []
      t.integer :sets,                null: false

      t.string  :weight_type,         null: false
      
      t.timestamps null: false
    end
  end
end
