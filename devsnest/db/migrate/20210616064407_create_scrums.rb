class CreateScrums < ActiveRecord::Migration[6.0]
  def change
    create_table :scrums do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :attendance
      t.boolean :saw_last_lecture
      t.string :till_which_tha_you_are_done
      t.string :what_will_you_cover_today
      t.string :reason_for_backlog_if_any
      t.integer :rate_yesterday_class

      t.timestamps
    end
  end
end
