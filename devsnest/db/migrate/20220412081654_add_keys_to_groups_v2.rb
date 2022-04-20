class AddKeysToGroupsV2 < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :version, :integer, default: 2
    add_column :groups, :group_type, :integer, default: 0
    add_column :groups, :language, :integer, default: 0
    add_column :groups, :classification, :integer, default: 0
    add_column :groups, :description, :text
    change_column :groups, :members_count, :integer, :default => 0

    Group.all.each { |group| group.update_attributes(:members_count => group.group_members.count, :version => 1) }
  end
end
