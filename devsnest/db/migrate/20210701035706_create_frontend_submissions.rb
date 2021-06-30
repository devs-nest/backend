# frozen_string_literal: true

# frontend submission migration
class CreateFrontendSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :frontend_submissions do |t|
      t.integer :user_id
      t.integer :content_id
      t.string :submission_link
      t.timestamps
    end
  end
end
