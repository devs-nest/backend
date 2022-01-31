class CreateManualLoginChangelogs < ActiveRecord::Migration[6.0]
  def change
    create_table :manual_login_changelogs do |t|
      t.integer :query_type
      t.text :uid
      t.boolean :is_fulfilled, :default => false
      t.integer :user_id
      t.index %i[user_id]
      t.timestamps
    end
  end
end
