class AddIndexToFeSubmission < ActiveRecord::Migration[6.0]
  def change
    add_index :fe_submissions, [:user_id, :frontend_challenge_id] , name: 'frontend_submission_user_index'
  end
end
