class AddIsSubmittedToAlgoSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :algo_submissions, :is_submitted, :boolean
  end
end
