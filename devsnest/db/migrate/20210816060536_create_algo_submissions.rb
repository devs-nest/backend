class CreateAlgoSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :algo_submissions do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.text :source_code
      t.integer :language_id
      t.json :test_cases
      t.integer :total_test_cases, default: 0
      t.integer :passed_test_cases, default: 0

      t.timestamps
    end
  end
end
