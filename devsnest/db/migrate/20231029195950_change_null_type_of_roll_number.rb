class ChangeNullTypeOfRollNumber < ActiveRecord::Migration[7.0]
  def change
    change_column_null :college_profiles, :roll_number, true
  end
end
