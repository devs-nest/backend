# frozen_string_literal: true

module Api
  module V1
    # Scrum Resourses
    class GroupResource < JSONAPI::Resource
      # caching
      attributes :name, :owner_id, :co_owner_id, :members_count, :student_mentor_id, :owner_name, :co_owner_name, :batch_leader_id, :slug, :created_at, :user_group, :group_type, :language,
                 :classification, :description, :version, :server_link, :scrum_start_time, :scrum_end_time, :activity_point, :bootcamp_type, :course_id
      has_many :group_members
      filter :classification
      filter :language
      filter :version
      filter :members, apply: lambda { |records, value, _options|
        records.where('members_count >= ? AND members_count <= ?', value[0], value[1])
      }
      filter :bootcamp_type
      filter :course_id

      filter :name, apply: lambda { |records, value, _options|
        records.where("name LIKE '%#{value.first}%'")
      }

      filter :language, apply: lambda { |records, value, _options|
        records.where(language: value)
      }

      filter :classification, apply: lambda { |records, value, _options|
        records.where(classification: value)
      }

      paginator :paged

      def description
        @model.description.dup.encode('ISO-8859-1').force_encoding('utf-8')
      rescue StandardError
        nil
      end

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

      def batch_leader_name
        scopeuser = User.find_by(id: batch_leader_id)
        return nil if scopeuser.nil?

        scopeuser.name
      end

      def user_group
        return false unless context[:user].present?

        GroupMember.where(user_id: context[:user].id).pluck(:group_id).each do |group_id|
          return true if group_id == @model.id
        end
        false
      end

      def server_link
        @model.server.link
      end

      def activity_point
        @model.activity_point
      end

      def self.records(options = {})
        if options[:context][:is_create] || options[:context][:slug].present? || options[:context][:group_id].present? || options[:context][:user]&.is_admin?
          super(options)
        else
          Group.eligible_groups.order(Arel.sql('activity_point desc, ((members_count % 15) - (members_count) % 5) / 10 desc, (members_count % 15) % 5'))
        end
      end
    end
  end
end
