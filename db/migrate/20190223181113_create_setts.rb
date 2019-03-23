class CreateSetts < ActiveRecord::Migration[5.2]
  def change
    create_table :setts do |t|
      t.integer     :set_goal,        null: false
      t.integer     :reps_completed,  null: false
      t.integer     :reps_goal,       null: false
      t.integer     :workout_id,      null: false
      t.integer     :exercise_id,     null: false
      t.integer     :weight,          null: false, default: 0

      t.timestamps  null: false
    end
  end
end
