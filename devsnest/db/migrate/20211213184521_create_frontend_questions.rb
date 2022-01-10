class CreateFrontendQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_questions do |t|
      t.text :question_markdown
      t.integer :template
      t.string :active_path
      t.text :open_paths
      t.text :protected_paths
      t.boolean :show_explorer
      t.text :hidden_files
    end
    
    create_table :minibootcamp_submissions do |t|
      t.integer :user_id
      t.integer :frontend_question_id
      t.boolean :is_solved
      t.string :submission_link
      t.string :submission_status
      t.index %i[user_id frontend_question_id], name: 'index_on_user_and_frontend_question', unique: true
    end
  end
end
