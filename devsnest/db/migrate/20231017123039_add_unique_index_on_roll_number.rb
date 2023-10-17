class AddUniqueIndexOnRollNumber < ActiveRecord::Migration[7.0]
  def change
    add_index :college_profiles, :roll_number, unique: true
  end
end
