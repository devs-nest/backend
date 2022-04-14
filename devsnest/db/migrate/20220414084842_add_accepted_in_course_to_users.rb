class AddAcceptedInCourseToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :accepted_in_course, :boolean, default: false
  end
end
