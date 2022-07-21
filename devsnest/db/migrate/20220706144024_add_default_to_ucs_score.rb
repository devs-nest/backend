class AddDefaultToUcsScore < ActiveRecord::Migration[6.0]
  def change
    change_column :user_challenge_scores, :score, :integer, :default => 0
  end
end
