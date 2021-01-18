
module Api
    module V1
        class GroupcallResource < JSONAPI::Resource
            attributes :user_id, :choice

            filter :choice, default: "yes"
            # filter :created_at, 
        end
    end
end