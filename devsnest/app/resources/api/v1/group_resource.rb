# frozen_string_literal: true

module Api
  module V1
    # Scrum Resourses
    class GroupResource < JSONAPI::Resource
      attributes :name, :owner_id, :co_owner_id, :members_count, :student_mentor_id, :owner_name, :co_owner_name, :batch_leader_id, :slug, :created_at, :user_group, :group_type, :language,
                 :classification, :description, :version, :server_link, :scrum_start_time, :scrum_end_time
      has_many :group_members
      filter :classification
      filter :language
      filter :version
      filter :members, apply: lambda { |records, value, _options|
        records.where('members_count >= ? AND members_count <= ?', value[0], value[1])
      }

      def scrum_start_time
        @model&.scrum_start_time&.to_formatted_s(:time)
      end

      def scrum_end_time
        @model&.scrum_end_time&.to_formatted_s(:time)
      end

      def owner_name
        scopeuser = User.find_by(id: owner_id)
        return nil if scopeuser.nil?

        scopeuser.name
      end

      def co_owner_name
        scopeuser = User.find_by(id: co_owner_id)
        return nil if scopeuser.nil?

        scopeuser.name
      end

      def user_group
        if context[:user].present?
          member_entity = GroupMember.find_by(user_id: context[:user].id)&.group_id
          group = Group.where(id: member_entity).first if member_entity.present?
          group == @model
        else
          false
        end
      end

      def server_link
        @model.server.link
      end

      def self.records(options = {})
        if options[:context][:is_create]
          super(options)
        elsif options[:context][:slug].present? || options[:context][:group_id].present?
          super(options)
        elsif options[:context][:fetch_all].present?
          super(options)
        elsif options[:context][:fetch_v1]
          user = options[:context][:user]
          group_ids = user.fetch_group_ids
          super(options).where(id: group_ids)
        elsif options[:context][:user]&.is_admin?
          super(options).v2
        else
          user_group = GroupMember.find_by(user_id: options[:context][:user]&.id)&.group
          user_group.present? ? user_group : super(options).v2.visible.under_limited_members
        end
      end
    end
  end
end
