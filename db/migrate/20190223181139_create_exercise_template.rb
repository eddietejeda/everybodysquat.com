class CreateExerciseTemplate < ActiveRecord::Migration[5.2]
  def change
    create_table :exercise_templates do |t|
      t.string :name, default: '', null: false
      t.timestamps null: false
    end
  end
end
