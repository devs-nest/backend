class AddCollegeProfile < ActiveRecord::Migration[6.0]
  def up
    create_table :college_profiles do |t|
      t.integer :user_id
      t.integer :college_id
      t.integer :authority_level # enum 
      t.integer :department
      t.string :email
  
      t.timestamps
    end
  
    create_table :college_invites do |t|
      t.integer :college_profile_id
      t.string :uid
      t.integer :status, default: 0 # enum
      t.integer :authority_level # enum 
      t.timestamps
    end
  end

  def down
    drop_table :college_profiles
    drop_table :college_invites
  end
end
