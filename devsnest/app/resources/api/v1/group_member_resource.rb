# frozen_string_literal: true

module Api
  module V1
    class GroupMemberResource < JSONAPI::Resource
      attributes :user_id, :group_id, :owner, :student_mentor, :scrum_master, :student_mentor, :batch_id
      attributes :user_details
      has_one :group
      def user_details
        user = User.find_by(id: @model.user_id)
        return {} unless user.present?
        { 'username': user.username, 'avatar': user.image_url }
      end
    end
  end
end
