class ModifyIndexAndAddBootcampTypeToGroupMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :bootcamp_type, :integer, default: 0

    remove_index :group_members, [:user_id]
    add_index :group_members, [:user_id]
  end
end
