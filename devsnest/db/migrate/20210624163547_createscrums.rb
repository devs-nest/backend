class Createscrums < ActiveRecord::Migration[6.0]
  def change
    create_table :scrums do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :attendance
      t.boolean :saw_last_lecture
      t.string :tha_progress
      t.string :topics_to_cover
      t.string :backlog_reasons
      t.integer :class_rating
      t.date :creation_date
      t.index [:user_id, :creation_date], unique: true

      t.timestamps
    end
  end
end
