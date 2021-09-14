class CreateNotificationBot < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_bots do |t|
      t.string :bot_token
      t.string :bot_username
      t.boolean :is_generic_bot, default: false
    end
  end
end
