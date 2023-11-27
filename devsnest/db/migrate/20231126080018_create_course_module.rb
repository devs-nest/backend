class CreateCourseModule < ActiveRecord::Migration[7.0]
  def change
    create_table :course_modules do |t|
      t.integer :course_id
      t.integer :module_type
      t.integer :questions_table
      t.integer :best_submissions_table
      t.integer :submissions_table
      
      t.timestamps
    end

    add_column :course_curriculums, :course_module_id, :integer
  end
end
