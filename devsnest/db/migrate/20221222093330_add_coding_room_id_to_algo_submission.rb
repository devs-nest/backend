class AddCodingRoomIdToAlgoSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :algo_submissions, :coding_room_id, :integer
    add_index :algo_submissions, %i[challenge_id coding_room_id]
  end
end