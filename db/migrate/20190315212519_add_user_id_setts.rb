class AddUserIdSetts < ActiveRecord::Migration[5.2]
  def change
    add_column :setts, :user_id, :integer, :default => 0, :null => false
  end
end
