class RenameUserUid < ActiveRecord::Migration[6.0]
  def change
  	remove_column :users, :uid
    remove_column :users, :active
    add_column :users, :discord_active, :boolean, default: false
    add_column :users, :web_active, :boolean, default: false
  end
end
