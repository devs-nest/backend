# frozen_string_literal: true

module Api
  module V1
    # Resource for Scrum
    class ScrumResource < JSONAPI::Resource
      attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                 :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating, :creation_date, :last_tha_link

      def self.creatable_fields(context)
        group = Group.find_by(id: context[:group_id_create])
        user = context[:user]
        if group.admin_rights_auth(user)
          super
        else
          super - %i[attendance]
        end
      end

      def self.updatable_fields(context)
        scrum = Scrum.find_by(id: context[:scrum_id])
        group = Group.find_by(id: scrum.group_id)
        if group.admin_rights_auth(context[:user])
          super - %i[user_id group_id creation_date]
        else
          super - %i[attendance user_id group_id creation_date]
        end
      end

      def self.records(options = {})
        group = Group.find_by(id: options[:context][:group_id_get])
        if group.present?
          super(options).where(group_id: group.id, creation_date: Date.parse(options[:context][:date]))
        else

          super(options)
        end
      end
    end
  end
end
