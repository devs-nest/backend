class AddCourseModuleStates < ActiveRecord::Migration[7.0]
  def change
    add_column :course_modules, :is_paid, :boolean, default: false
    add_column :course_modules, :timeline_status, :integer, default: 0
    add_column :course_modules, :college_id, :integer
  end
end
