class CreateTableFileUploadRecord < ActiveRecord::Migration[7.0]
  def change
    create_table :file_upload_records do |t|
      t.integer :status
      t.integer :file_type
      t.integer :user_id
      t.string :file
      t.timestamps
    end
  end
end
