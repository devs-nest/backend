class AddColumnToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :server_id, :integer, default: 1
  end
end
