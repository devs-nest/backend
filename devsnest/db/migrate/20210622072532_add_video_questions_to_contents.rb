class AddVideoQuestionsToContents < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :video_questions, :json
    add_column :contents, :reference_data, :json
  end
end
