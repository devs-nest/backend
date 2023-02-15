class AddResultToBeSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :be_submissions, :result, :text
  end
end
