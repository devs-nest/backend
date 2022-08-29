class CreateFrontendSubmission < ActiveRecord::Migration[6.0]
  def change
    create_table :fe_submissions do |t|
      t.integer :user_id
      t.integer :frontend_challenge_id
      t.integer :total_test_cases, default: 0
      t.integer :passed_test_cases, default: 0
      t.integer :score, defualt: 0
      t.text :result
      t.string :question_type
      t.boolean :is_submitted, default: false
      t.text :source_code
    end
  end
end
