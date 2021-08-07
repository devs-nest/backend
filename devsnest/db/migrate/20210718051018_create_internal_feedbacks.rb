# frozen_string_literal: true

class CreateInternalFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :internal_feedbacks do |t|
      t.belongs_to :user, index: true
      t.boolean :is_resolved, default: false
      t.string :issue_type, default: ''
      t.text :issue_described
      t.text :feedback
      t.integer :issue_scale, default: 0

      t.timestamps
    end
  end
end
