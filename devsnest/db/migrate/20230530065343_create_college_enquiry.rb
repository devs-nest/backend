class CreateCollegeEnquiry < ActiveRecord::Migration[7.0]
  def change
    create_table :college_enquiries do |t|
      t.string :phone_number
      t.integer :enquiry_count, default: 0
      t.timestamps

      t.index :phone_number
    end
  end
end
