class AddEduEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :edu_events do |t|
      t.string :title
      t.text :description
      t.date :starting_date
      t.date :ending_date
      t.string :organizer
      t.json :form_columns

      t.timestamps
    end

    create_table :event_registrations do |t|
      t.integer :edu_event_id
      t.integer :user_id
      t.json :user_data
      t.index [:user_id, :edu_event_id], unique: true
      t.index :edu_event_id

      t.timestamps
    end
  end
end
