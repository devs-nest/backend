class AddColumnToNotificationBotTable < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_bots, :is_used, :boolean ,default: false
  end
end
