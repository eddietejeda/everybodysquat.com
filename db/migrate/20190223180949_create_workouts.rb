class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.text    :notes,           null: true, default: ''
      t.integer :user_id,         null: false
      t.integer :routine_id,      null: false
      t.string  :exercise_group,  null: false, default: ''
      t.boolean :active,          null: false, default: false

      t.timestamps null: false

    end
  end
end
