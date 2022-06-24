class AlgoSubmissionOpt < ActiveRecord::Migration[6.0]
  def change
    remove_index :algo_submissions, name: "index_algo_submissions_all"
    add_index :algo_submissions, [:user_id, :challenge_id]
  end
end
