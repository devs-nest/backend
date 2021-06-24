# frozen_string_literal: true

module Api
  module V1
    class ScrumResource < JSONAPI::Resource
      attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                  :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating, :creation_date

      def self.creatable_fields(context)
        group = Group.find_by(id: context[:group_id])
        user = context[:user]
        unless group.admin_rights_auth(user)
          super - %i[attendance]
        else
          super
        end
      end

      def self.updatable_fields(context)
        group = Group.find_by(id: context[:group_id])
        user = context[:user]
        if group.admin_rights_auth(user)
          super - %i[user_id group_id creation_date]
        else
          super - %i[attendance user_id group_id creation_date]
        end
      end

      def self.records(options = {})
        group = Group.where(id:options[:context][:group_id]).first
        group_id = options[:context][:group_id] if options[:context][:user].user_type == 'admin' || options[:context][:user].id == group.batch_leader_id
        group_id = GroupMember.find_by(user_id: options[:context][:user].id).group_id if options[:context][:user].user_type == 'user'
        
        super(options).where(group_id: group_id, creation_date: Date.current)
      end
    end
  end
end
