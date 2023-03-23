class ChangeDefaultUniqueId < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:coding_rooms, :unique_id, nil)
  end
end
