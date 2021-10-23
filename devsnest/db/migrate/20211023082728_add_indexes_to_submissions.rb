class AddIndexesToSubmissions < ActiveRecord::Migration[6.0]
  def change
    add_index :algo_submissions, :user_id
    add_index :algo_submissions, :challenge_id
  end
end
