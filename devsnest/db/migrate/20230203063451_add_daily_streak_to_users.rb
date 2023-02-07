class AddDailyStreakToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dsa_streak, :integer, default: 0
    add_column :users, :streak_end_date, :datetime
    add_column :users, :last_dsa_streak, :integer, default: 0
  end
end
