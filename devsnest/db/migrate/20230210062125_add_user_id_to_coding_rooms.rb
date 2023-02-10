class AddUserIdToCodingRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :coding_rooms, :user_id, :integer, null: false
  end
end
