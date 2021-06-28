class AddbatchLeaderSheets < ActiveRecord::Migration[6.0]
  def change
    create_table :batch_leader_sheets do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :tha_by_owner
      t.integer :tha_by_co_owner
      t.boolean :scrum_sheet_filled
      t.boolean :meet_with_industry_mentor
      t.boolean :owner_active
      t.boolean :co_owner_active
      t.string :remarks
      t.string :topics_to_cover
      t.integer :rating
      t.date :creation_date
      t.text :active_members
      t.text :par_active_members
      t.text :inactive_members  
      t.text :extra_activity
      t.text :doubt_session_taker
    end
  end
end
