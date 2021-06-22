# frozen_string_literal: true

module Api
  module V1
    class ScrumResource < JSONAPI::Resource
      attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                  :till_which_tha_you_are_done, :what_will_you_cover_today, :reason_for_backlog_if_any, :rate_yesterday_class

      def self.creatable_fields(context)
        group = Group.find_by(id: context[:group_id])
        user_id = context[:user].id
        unless Scrum.check_scrum_auth(user_id,group)
          super - %i[attendance]
        else
          super - %i[]
        end
      end

      def self.updatable_fields(context)
        group = Group.find_by(id: context[:group_id])
        user_id = context[:user].id
        if Scrum.check_scrum_auth(user_id,group)
          super - %i[user_id group_id]
        else
          super - %i[attendance user_id group_id]
        end
      end

      def self.records(options = {})
        group_id = options[:context][:group_id] if options[:context][:user].user_type == 'admin'
        group_id = GroupMember.find_by(user_id: options[:context][:user].id).group_id if options[:context][:user].user_type == 'user'
        
        super(options).where(group_id: group_id, created_at: Date.current.beginning_of_day..Date.current.end_of_day)
      end
    end
  end
end
