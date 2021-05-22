class College < ApplicationRecord
    # belongs_to :batch
    belongs_to :user

    def self.update_college_name(user_id, college_name)
      college_data = College.find_by(user_id: user_id)
      college_data.name = college_name 
      college_data.save    
    end  
  
  end