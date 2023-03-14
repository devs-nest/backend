class AddBootcampTypeToGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :bootcamp_type, :integer, default: 0
  end
end
