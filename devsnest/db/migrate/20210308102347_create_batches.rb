# frozen_string_literal: true

class CreateBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.integer :owner_id
      t.string :name,              null: false, default: ''
      t.integer :members_count
      t.integer :student_mentor_id
      t.timestamps null: false
    end
  end
end

