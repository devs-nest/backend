class AddUserTypeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :user_type, :integer,default: 0
    add_column :users, :bot_token, :string
    add_column :users, :google_id, :string
  end
end
