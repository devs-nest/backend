class AddNameToCourseModule < ActiveRecord::Migration[7.0]
  def change
    add_column :course_modules, :name, :string
  end
end
