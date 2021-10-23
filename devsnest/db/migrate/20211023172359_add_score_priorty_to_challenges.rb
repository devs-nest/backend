class AddScorePriortyToChallenges < ActiveRecord::Migration[6.0]
  def change
    add_column :challenges, :score, :integer, default: 0
    add_column :challenges, :priority, :integer
  end
end
