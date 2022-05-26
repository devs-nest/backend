class ChangeResourcesColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :course_curriculums, :resources, :json
  end
end
