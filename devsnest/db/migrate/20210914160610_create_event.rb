class CreateEvent < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :event_type
      t.text :message
      t.integer :bot_type
      t.string :bot_details
      t.timestamps
    end
  end
end
