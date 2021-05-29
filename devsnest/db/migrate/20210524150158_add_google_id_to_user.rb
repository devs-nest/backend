class AddGoogleIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :google_id, :string, null: false, default: ''
    add_column :users, :bot_token, :string, null: false, default: ''
  end
end
