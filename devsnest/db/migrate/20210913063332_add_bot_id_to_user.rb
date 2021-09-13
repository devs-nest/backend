class AddBotIdToUser < ActiveRecord::Migration[6.0]
  def change
     add_column :users, :bot_id, :int 
  end
end
