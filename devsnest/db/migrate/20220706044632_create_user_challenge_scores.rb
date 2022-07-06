class CreateUserChallengeScores < ActiveRecord::Migration[6.0]
  def change
    create_table :user_challenge_scores do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.integer :algo_submission_id
      t.integer :total_test_cases
      t.integer :passed_test_cases
      t.integer :score, defualt: 0

      t.index [:user_id, :challenge_id], unique: true
      t.timestamps
    end
  end
end
