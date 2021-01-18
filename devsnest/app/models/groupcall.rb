class Groupcall < ApplicationRecord

    enum choice: %i[no yes]




    def self.get_slot
        user_array = Groupcall.where(choice: 'yes').pluck(:user_id)
        user_count = user_array.count
        # puts 'test'
        # p abc

        0.upto(user_count-1).each do |i|

            group_id = i/4+1

            gr = Groupcall.find_by(user_id: user_array[i]) 
            
            gr.group_id = group_id       
                 
            gr.save
        end
    end

    
    def self.fetch_groups
        self.get_slot
        groups = Groupcall.where({ created_at: (Date.today.beginning_of_week.last_week)..(Date.today.beginning_of_week.last_week + 8) }).all
        groups = groups.where(:choice => "yes").pluck(:user_id, :group_id)
        

        return groups

    end

end