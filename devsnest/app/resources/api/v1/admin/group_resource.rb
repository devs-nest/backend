# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource for Group
      class GroupResource < JSONAPI::Resource
        attributes :name, :owner_id, :co_owner_id, :members_count, :student_mentor_id, :owner_name, :co_owner_name, :batch_leader_id, :slug, :created_at, :user_group, :group_type, :language,
                   :classification, :description, :version, :server_link, :scrum_start_time, :scrum_end_time

        def scrum_start_time
          @model&.scrum_start_time&.to_formatted_s(:time)
        end

        def scrum_end_time
          @model&.scrum_end_time&.to_formatted_s(:time)
        end
      end
    end
  end
end
