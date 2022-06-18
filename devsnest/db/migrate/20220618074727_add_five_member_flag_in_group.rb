class AddFiveMemberFlagInGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :five_members_flag, :boolean, default: false
  end
end
