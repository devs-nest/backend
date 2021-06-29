class AddbatchLeaderSheets < ActiveRecord::Migration[6.0]
  def change
    create_table :batch_leader_sheets do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :Coordination
      t.integer :scrum_filled
      t.integer :owner_active
      t.integer :co_owner_active
      t.integer :rating
      t.date :creation_week
      t.text :active_members
      t.text :par_active_members
      t.text :inactive_members  
      t.text :doubt_session_taker
      t.index [:group_id, :creation_week], unique: true
    end
  end
end
