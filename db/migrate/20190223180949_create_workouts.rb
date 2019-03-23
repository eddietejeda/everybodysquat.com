class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table  :workouts do |t|
      t.integer   :user_id,         null: false
      t.integer   :routine_id,      null: false
      t.boolean   :active,          null: false,  default: false
      t.string    :exercise_group,  null: false,  default: ''
      t.jsonb     :training_maxes,  null: false,  default: '{}'
      t.text      :notes,           null: true,   default: ''
      
      t.timestamps null: false

    end
  end
end