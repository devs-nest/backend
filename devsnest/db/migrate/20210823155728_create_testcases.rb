class CreateTestcases < ActiveRecord::Migration[6.0]
  def change
    create_table :testcases do |t|
      t.integer :challenge_id
      t.boolean :is_sample
      t.string :input_path
      t.string :output_path
      
      t.timestamps
    end
  end
end
