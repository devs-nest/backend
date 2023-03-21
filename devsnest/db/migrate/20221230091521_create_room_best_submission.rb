class CreateRoomBestSubmission < ActiveRecord::Migration[6.0]
  def change
    create_table :room_best_submissions do |t|
      t.integer :challenge_id
      t.integer :user_id
      t.integer :coding_room_id
      t.integer :algo_submission_id
      t.integer :total_test_cases
      t.integer :passed_test_cases
      t.integer :score, defualt: 0

      t.index [:user_id, :challenge_id, :coding_room_id],name: "index_room_best_submission", unique: true
      t.timestamps
    end
  end
end
