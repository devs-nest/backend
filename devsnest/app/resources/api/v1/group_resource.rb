# frozen_string_literal: true

module Api
  module V1
    # Scrum Resourses
    class GroupResource < JSONAPI::Resource
      attributes :name, :owner_id, :co_owner_id, :members_count, :student_mentor_id, :owner_name, :co_owner_name, :batch_leader_id, :slug, :created_at
      has_many :group_members

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

      def self.records(options = {})
        user = options[:context][:user]
        group_ids = user.fetch_group_ids
        super(options).where(id: group_ids)
      end
    end
  end
end
