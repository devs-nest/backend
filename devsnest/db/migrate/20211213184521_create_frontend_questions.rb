class CreateFrontendQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_questions do |t|
      t.integer :minibootcamp_id
      t.text :question_markdown
    end

    create_table :minibootcamp_submissions do |t|
      t.integer :user_id
      t.integer :frontend_question_id
      t.string :submission_link
      t.string :submission_status
      t.index %i[frontend_question_id] 
    end
  end
end
