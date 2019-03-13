class CreateRoutines < ActiveRecord::Migration[5.2]
  def change
    create_table :routines do |t|
      t.string  :name,                  null: false,  default: ''
      t.text    :description,           null: false,  default: ''
      t.string  :exercise_groups,       array: true,  default: []
      t.timestamps null: false
    end
  end
end
