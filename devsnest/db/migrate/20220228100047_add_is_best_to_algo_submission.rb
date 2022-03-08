class AddIsBestToAlgoSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :algo_submissions, :is_best_submission, :boolean, :default => false
  end
end
