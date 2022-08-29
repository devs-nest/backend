class CreateFrontendChallengeScore < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_challenge_scores do |t|
      t.integer :user_id
      t.integer :frontend_challenge_id
      t.integer :fe_submission_id
      t.integer :total_test_cases, default: 0
      t.integer :passed_test_cases, default: 0
      t.integer :score, defualt: 0
      t.index [:user_id, :frontend_challenge_id], unique: true , name: 'frontend_challenge_score_index'
      t.timestamps
    end
  end
end
