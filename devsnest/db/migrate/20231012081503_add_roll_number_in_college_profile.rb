class AddRollNumberInCollegeProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :college_profiles, :roll_number, :string, null: false
  end
end
