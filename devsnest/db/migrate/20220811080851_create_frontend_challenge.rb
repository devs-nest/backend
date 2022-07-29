class CreateFrontendChallenge < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_challenges do |t|
      t.string :name
      t.integer :day_no
      t.string  :folder_name
      t.integer :topic
      t.integer :difficulty
      t.string :slug
      t.text :question_body
      t.integer :score, :default=> 0
      t.boolean :is_active, :default=> false
      t.integer :user_id
      t.integer :course_curriculum_id
      t.string :testcases_path
      t.text :hidden_files
      t.text :protected_paths
      t.text :open_paths
      t.string :template
      t.string :active_path
      t.string :challenge_type
      t.text :files
      t.timestamps
      t.index [:slug], unique: true
    end
  end
end
