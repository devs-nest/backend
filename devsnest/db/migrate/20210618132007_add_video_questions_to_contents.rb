class AddVideoQuestionsToContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :video_questions, :text
  end
end
