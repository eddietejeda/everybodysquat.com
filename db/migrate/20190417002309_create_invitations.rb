class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.integer :user_id,           null: false
      t.string  :email,             default: ''

      t.timestamps
    end
  end
end
