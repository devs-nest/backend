# frozen_string_literal: true

module Api
    module V1
      class ScrumResource < JSONAPI::Resource
        attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                   :till_which_tha_you_are_done, :what_will_you_cover_today, :reason_for_backlog_if_any, :rate_yesterday_class
  
        def self.updatable_fields(context)
          scrum_group_owner_id = Group.find_by(id: context[:scrum].group_id).owner_id
          scrum_group_co_owner_id = Group.find_by(id: context[:scrum].group_id).co_owner_id
          if context[:user].id == scrum_group_owner_id || context[:user].id == scrum_group_co_owner_id || context[:user].user_type == 'admin'
            super - %i[user_id group_id]
          else
            super - %i[attendance user_id group_id]
          end
        end
  
        def self.records(options = {})
          group_id = GroupMember.find_by(user_id: options[:context][:user].id).group_id
          super(options).where(group_id: group_id, created_at: Date.current.beginning_of_day + 5.hour + 30.minute..Date.current.end_of_day + 5.hour + 30.minute)
        end
      end
    end
  end
  