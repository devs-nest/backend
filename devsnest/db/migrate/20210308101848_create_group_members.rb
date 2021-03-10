class CreateGroupMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :group_members do |t|
      t.boolean :scrum_master
      t.boolean :owner
      t.boolean :student_mentor
      t.integer :user_id
      t.integer :group_id
      t.integer :batch_id
      t.integer :members_count
      t.integer :student_mentor_id
      t.timestamps null: false
    end
  end
end
