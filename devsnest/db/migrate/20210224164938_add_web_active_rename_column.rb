class AddWebActiveRenameColumn < ActiveRecord::Migration[6.0]
  def change
    # todo: handle false values for existing user
    remove_column :users, :active
    add_column :users, :discord_active, :boolean, default: false
    add_column :users, :web_active, :boolean, default: false
  end
end
