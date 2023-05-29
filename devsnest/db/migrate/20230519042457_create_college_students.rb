class CreateCollegeStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :college_students do |t|
      t.string :name
      t.string :phone
      t.date :dob
      t.string :email
      t.integer :gender

      t.string :parent_name
      t.string :parent_phone
      t.string :parent_email

      t.integer :high_school_board_type
      t.string :high_school_board
      t.string :high_school_name
      t.string :high_school_passing_year
      t.integer :high_school_result

      t.string :diploma_university_name
      t.string :diploma_passing_year
      t.integer :diploma_result

      t.integer :higher_secondary_board_type
      t.string :higher_secondary_board
      t.string :higher_secondary_school_name
      t.string :higher_secondary_passing_year
      t.integer :higher_secondary_result

      t.integer :state, default: 0
      t.integer :higher_education_type
      t.boolean :phone_verified, default: false
      t.integer :user_id

      t.timestamps
    end

    add_column :users, :is_college_student, :boolean, default: false
  end
end
