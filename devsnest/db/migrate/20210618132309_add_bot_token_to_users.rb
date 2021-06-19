class AddBotTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bot_token, :string
  end
end
