class CreateEvent < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :message
      t.string :bot_type
      t.timestamps
    end
  end
end
