class AddScrumTimeToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :scrum_start_time, :time, default: Time.new(2003, 12, 31, 14, 30, 0, "+05:30")
    add_column :groups, :scrum_end_time, :time, default: Time.new(2003, 12, 31, 15, 0, 0, "+05:30")
  end
end
