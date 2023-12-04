class CourseModuleAccess < ActiveRecord::Migration[7.0]
  def change
    create_table :course_module_access do |t|
      t.references :accessible, polymorphic: true, null: false, index: true
      t.integer :status

      t.timestamps
    end
  end
end
