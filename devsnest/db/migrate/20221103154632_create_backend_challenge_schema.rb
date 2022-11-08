class CreateBackendChallengeSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :be_submissions do |t|
      t.integer :user_id
      t.integer :backend_challenge_id
      t.integer :total_test_cases, default: 0
      t.integer :passed_test_cases, default: 0
      t.text :failed_test_cases
      t.float :score
      t.text :submitted_url
      t.string :status
      t.index ["user_id", "backend_challenge_id"], name: "backend_submission_user_index"

      t.timestamps
    end

    create_table :backend_challenge_scores do |t|
      t.integer :user_id
      t.integer :backend_challenge_id
      t.integer :be_submission_id
      t.integer :total_test_cases, default: 0
      t.integer :passed_test_cases, default: 0
      t.float :score
      t.index ["user_id", "backend_challenge_id"], name: "backend_challenge_score_index", unique: true

      t.timestamps
    end

    create_table :backend_challenges do |t|
      t.string :name
      t.integer :day_no
      t.integer :topic
      t.integer :difficulty
      t.string :slug
      t.integer :score, default: 0
      t.boolean :is_active, default: false
      t.integer :user_id
      t.integer :course_curriculum_id
      t.string :testcases_path
      t.index ["slug"], name: "index_backend_challenges_on_slug", unique: true

      t.timestamps
    end

    add_column :users, :be_score, :integer, default: 0
  end
end
