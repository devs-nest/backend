class AddingBotTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bot_token, :string, null: false, default: ''
  end
end
