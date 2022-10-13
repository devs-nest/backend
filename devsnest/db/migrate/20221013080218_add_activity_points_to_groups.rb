class AddActivityPointsToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :activity_point, :integer, default: 0
  end
end
