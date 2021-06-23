# frozen_string_literal: true

module Api
  module V1
    class ScrumResource < JSONAPI::Resource
      attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                  :till_which_tha_you_are_done, :what_will_you_cover_today, :reason_for_backlog_if_any, :rate_yesterday_class, :date

      def self.creatable_fields(context)
        group = Group.find_by(id: context[:group_id])
        user = context[:user]
        unless group.check_scrum_edit_auth(user)
          super - %i[attendance]
        else
          super
        end
      end

      def self.updatable_fields(context)
        group = Group.find_by(id: context[:group_id])
        user = context[:user]
        if group.check_scrum_edit_auth(user)
          super - %i[user_id group_id date]
        else
          super - %i[attendance user_id group_id date]
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
