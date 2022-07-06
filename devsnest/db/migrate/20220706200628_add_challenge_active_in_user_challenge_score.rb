class AddChallengeActiveInUserChallengeScore < ActiveRecord::Migration[6.0]
  def change
    add_column :user_challenge_scores, :challenge_active, :boolean, :default => false
  end
end
