class AddColumsToCourseModuleAccess < ActiveRecord::Migration[7.0]
  def change
    add_reference :course_module_access, :course_modules, foreign_key: true, null: false, index: true
    add_column :course_modules, :visibility, :integer, default: 0
  end
end
