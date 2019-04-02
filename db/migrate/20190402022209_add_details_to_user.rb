class AddDetailsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :details,    :jsonb
  end
end
