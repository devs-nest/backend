class AddBootCampAutomation < ActiveRecord::Migration[6.0]
  def change
    create_table :bootcamp_progresses do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :course_curriculum_id
      t.boolean :completed, default: false
      
      t.index %i[user_id], unique: true

      t.timestamps
    end

    add_column :course_curriculums, :extra_data, :json
  end
end
