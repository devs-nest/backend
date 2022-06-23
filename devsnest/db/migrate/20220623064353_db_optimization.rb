class DbOptimization < ActiveRecord::Migration[6.0]
  def change
    remove_index :algo_submissions, name: "index_algo_submissions_on_user_id_and_challenge_id"
    add_index :algo_submissions, [:user_id, :challenge_id, :is_submitted, :status], name: "index_algo_submissions_all"
    add_index :algo_submissions, [:is_submitted, :status]
    add_index :testcases, [:challenge_id, :is_sample]
  end
end
