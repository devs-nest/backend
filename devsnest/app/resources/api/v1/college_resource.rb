# frozen_string_literal: true

module Api
  module V1
    class CollegeResource < JSONAPI::Resource
      attributes :name, :is_verified, :invites, :members

      def invites
        @model.college_invites.as_json
      end

      def members
        @model.college_profiles.where(department: context[:user].college_profile.department).where.not(user_id: nil).as_json
      end
    end
  end
end
