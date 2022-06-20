class AddServerUserTables < ActiveRecord::Migration[6.0]
  def change
    create_table :server_users do |t|
      t.integer :user_id
      t.integer :server_id
    end
  end
end