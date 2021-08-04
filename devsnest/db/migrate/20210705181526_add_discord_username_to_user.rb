class AddDiscordUsernameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discord_username, :string
    add_column :users, :school, :string
    add_column :users, :work_exp, :string
    add_column :users, :known_from, :string
    add_column :users, :dsa_skill, :integer, default: 0
    add_column :users, :webd_skill, :integer, default: 0
    add_column :users, :is_discord_form_filled, :boolean, default:false
  end
end
