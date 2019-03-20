class CreateBodies < ActiveRecord::Migration[5.2]
  def change
    create_table :bodies do |t|

      t.integer :user_id,               null: true,  default: 0
      t.integer :weight,                null: true,  default: 0
      t.integer :fat_percent,           null: true,  default: 0
      t.integer :muscle_percent,        null: true,  default: 0
      t.integer :water_percent,         null: true,  default: 0

      t.timestamps
    end
  end
end
