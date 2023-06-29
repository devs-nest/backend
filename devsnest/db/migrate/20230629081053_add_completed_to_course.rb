class AddCompletedToCourse < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :completed, :boolean, default: false
  end
end
