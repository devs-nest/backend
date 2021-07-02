class CreateFrontendSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_submissions do |t|
      t.integer :user_id
    	t.integer :content_id
    	t.integer :submission_link
      t.integer :status

      t.timestamps
    end
  end
end
