class AddIndexesToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_index :algo_submissions, [:user_id, :challenge_id]
  end
end
