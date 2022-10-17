class AddListmonkSubscriberIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :listmonk_subscriber_id, :integer
  end
end
