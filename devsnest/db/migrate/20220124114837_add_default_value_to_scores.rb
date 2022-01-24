class AddDefaultValueToScores < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :score, :integer, :default => 0
  end
end
