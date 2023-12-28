class CreateCourseModuleMapping < ActiveRecord::Migration[7.0]
  def change
    create_table :course_module_mappings do |t|
      t.integer :course_module_id
      t.integer :course_id

      t.index [:course_id, :course_module_id], name: 'course_module_mapping_index'
      t.timestamps
    end
  end
end
