class AddUserIdToCodingRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :coding_rooms, :user_id, :integer, null: false
    add_column :coding_rooms, :starts_at, :datetime, null: false
    add_column :coding_rooms, :difficulty, :string, null: false
    add_column :coding_rooms, :question_count, :integer, null: false
  end
end
