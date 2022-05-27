class AddGroupFlagToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :previously_joined_a_group, :boolean, default: false
  end
end
