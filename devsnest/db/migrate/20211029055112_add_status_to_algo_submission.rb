class AddStatusToAlgoSubmission < ActiveRecord::Migration[6.0]
  def change
    add_column :algo_submissions, :status, :string
    add_column :algo_submissions, :total_runtime, :string
    add_column :algo_submissions, :total_memory, :string
  end
end
