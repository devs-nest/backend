class CreateFrontendQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_questions do |t|
      t.integer :minibootcamp_id
      t.text :question_markdown
    end

    create_table :minibootcamp_submissions do |t|
      t.integer :user_id
      t.string :minibootcamp_id
      t.string :submission_link
    end
  end
end
