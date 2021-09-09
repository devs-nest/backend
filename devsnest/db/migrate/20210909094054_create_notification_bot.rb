class CreateNotificationBot < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_bots do |t|
      t.json :user_id
      t.integer :bot_token
      t.text :message
    
      t.timestamps
    end
  end
end
