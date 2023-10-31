class AddUniqueIndexOnCollegeProfile < ActiveRecord::Migration[7.0]
  def change
    add_index :college_profiles, [:user_id, :college_id], unique: true
  end
end
