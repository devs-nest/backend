class AddCourseRelationToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :course_id, :integer
  end
end
