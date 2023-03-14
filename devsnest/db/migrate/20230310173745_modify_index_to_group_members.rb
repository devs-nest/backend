class ModifyIndexToGroupMembers < ActiveRecord::Migration[6.0]
  def change
    remove_index :group_members, [:user_id]
    add_index :group_members, [:user_id]
  end
end
