class AddSqlEditorChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :sql_challenges do |t|
      t.string :title
      t.integer :score
      t.integer :difficulty
      t.boolean :is_active
      t.string :created_by
      t.integer :user_id
      t.string :slug
      t.string :topic
      t.text :question_body
      t.boolean :status
      t.text :expected_output
      t.string :initial_sql_file

      t.index [:user_id], name: 'sql_challenge_user_index'

      t.timestamps
    end

    create_table :sql_submissions do |t|
      t.integer :user_id
      t.integer :sql_challenge_id
      t.integer :score
      t.boolean :passed

      t.index [:user_id, :sql_challenge_id], name: 'sql_submission_user_challenge_index'

      t.timestamps
    end
  end
end
