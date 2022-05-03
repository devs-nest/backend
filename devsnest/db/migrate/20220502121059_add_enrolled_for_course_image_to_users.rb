class AddEnrolledForCourseImageToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :enrolled_for_course_image_url, :string
  end
end
