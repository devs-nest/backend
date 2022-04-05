class CreateCollegeForm < ActiveRecord::Migration[6.0]
  def change
    create_table :college_forms do |t|
      t.integer :user_id, unique: true
      t.string :tpo_or_faculty_name, null: false
      t.string :college_name
      t.string :faculty_position
      t.string :email
      t.string :phone_number
      t.timestamps
    end

    add_column :users, :is_college_form_filled, :boolean, default: false
  end
end
