class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.text :message
      t.boolean :is_sent,default: false
      t.date :date_to_be_sent    
      t.timestamps
    end
  end
end
