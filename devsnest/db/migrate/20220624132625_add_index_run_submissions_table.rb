class AddIndexRunSubmissionsTable < ActiveRecord::Migration[6.0]
  create_table :run_submissions do |t|
    t.integer :user_id
    t.integer :challenge_id
    t.text :source_code
    t.string :language
    t.json :test_cases
    t.integer :total_test_cases, default: 0
    t.integer :passed_test_cases, default: 0
    t.string :total_runtime
    t.string :total_memory
    t.string :status
    t.index [:user_id, :challenge_id]

    t.timestamps
  end
  # drop_table :run_submissions
end
