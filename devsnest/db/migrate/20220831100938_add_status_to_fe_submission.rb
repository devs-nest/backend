class AddStatusToFeSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :fe_submissions, :status, :string
  end
end
