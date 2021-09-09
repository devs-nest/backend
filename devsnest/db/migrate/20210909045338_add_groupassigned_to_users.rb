class AddGroupassignedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :group_assigned, :boolean, default: false
  end
end
