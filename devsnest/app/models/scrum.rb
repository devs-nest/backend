# frozen_string_literal: true

class Scrum < ApplicationRecord

    def self.check_scrum_auth(user_id,group)
        user = User.find_by(id:user_id)
        return true if user_id == group.owner_id || user_id == group.co_owner_id || user_id == group.batch_leader_id || user.user_type == 'admin'
        false
    end
end
