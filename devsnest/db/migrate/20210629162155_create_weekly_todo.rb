class CreateWeeklyTodo < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_todos do |t|
      t.integer :group_id
      t.boolean :sheet_filled
      t.date :creation_week
      t.integer :batch_leader_rating
      t.integer :group_activity_rating
      t.string :extra_activity
      t.string :comments
      t.integer :moral_status
      t.string :obstacles
      t.json :todo_list
      t.index %i[group_id creation_week], unique: true
    end
  end
end
