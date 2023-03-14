class ChangeStreakEndDateType < ActiveRecord::Migration[6.0]
  def change
    change_column(:users, :streak_end_date, :date)
  end
end
