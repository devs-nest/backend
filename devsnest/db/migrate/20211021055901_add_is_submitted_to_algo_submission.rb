class AddIsSubmittedToAlgoSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :algo_submissions, :is_submitted, :boolean
    add_column :algo_submissions, :status, :string
    add_column :algo_submissions, :total_runtime, :string
    add_column :algo_submissions, :total_memory, :string
    add_index :algo_submissions, [:user_id, :challenge_id]
  end
end
