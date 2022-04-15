class AddUniqueCompundIndexToGroupMembers < ActiveRecord::Migration[6.0]
  def change
    add_index :group_members, [:user_id], unique: true 
    add_index :group_members, [:user_id, :group_id], unique: true 
  end
end
