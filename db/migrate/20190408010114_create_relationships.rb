class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :user_id,           null: false
      t.integer :follow_user_id,    null: false
      t.boolean :approved,          null: false, default: false
      t.string  :nonce,             null: true
      t.timestamps
    end
  end
end


