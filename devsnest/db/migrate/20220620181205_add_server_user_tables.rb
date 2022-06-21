class AddServerUserTables < ActiveRecord::Migration[6.0]
  def change
    create_table :server_users do |t|
      t.integer :user_id
      t.integer :server_id
      t.boolean :active, default: false
      t.timestamps
    end
    add_index :server_users, [:user_id, :server_id]
  end
end