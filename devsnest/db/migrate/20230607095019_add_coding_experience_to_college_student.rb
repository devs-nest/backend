class AddCodingExperienceToCollegeStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :college_students, :coding_exp, :text
    add_column :college_students, :coding_summary, :text
  end
end
