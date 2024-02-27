class CreateTableFileUploadRecord < ActiveRecord::Migration[7.0]
  def change
    create_table :file_upload_records do |t|
      t.integer :status
      t.integer :file_type
      t.date :start_date
      t.date :end_date
      t.string :filename
      t.integer :user_id
      t.string :file
      t.timestamps
    end
  end
end
