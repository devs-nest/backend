class AddUnsubscribeTable < ActiveRecord::Migration[6.0]
  def change
    create_table :unsubscribes do |t|
      t.integer :user_id
      t.integer :category, default: 0
      t.index %i[user_id category], unique: true

      t.timestamps
    end
  end
end
