class AddGranularityTypeToCourseModule < ActiveRecord::Migration[7.0]
  def change
    add_column :course_modules, :granularity_type, :integer, default: 0, null: false
    add_column :course_curriculums, :contents, :text
  end
end
