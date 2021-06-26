# frozen_string_literal: true

module Api
  module V1
    class ScrumResource < JSONAPI::Resource
      attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                 :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating, :creation_date

      def self.creatable_fields(context)
        group = Group.find_by(id: context[:params][:data][:attributes][:group_id])
        user = context[:user]
        if group.admin_rights_auth(user)
          super
        else
          super - %i[attendance]
        end
      end

      def self.updatable_fields(context)
        scrum = Scrum.find_by(id: context[:params][:id])
        group = Group.find_by(id: scrum.group_id)
        if group.admin_rights_auth(context[:user])
          super - %i[user_id group_id creation_date]
        else
          super - %i[attendance user_id group_id creation_date]
        end
      end

      def self.records(options = {})
        if options[:context][:params][:action] == 'index'
          super(options).where(group_id: options[:context][:params][:group_id], creation_date: Date.current)
        else
          super(options)
        end
      end
    end
  end
end
