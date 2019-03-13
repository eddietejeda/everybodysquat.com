class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.integer :routine_id,        null: false
      t.integer :exercise_id,       null: false
      t.integer :sets,              null: false
      t.integer :reps,              null: false
      t.string  :progression_type,  null: false
      t.string  :exercise_group,    null: false
      t.integer :incremention_scheme,   null: true, array: true, default: []
      
      t.timestamps null: false
    end
  end
end
