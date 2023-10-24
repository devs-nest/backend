# frozen_string_literal: true

module Api
  module V1
    class CollegeResource < JSONAPI::Resource
      attributes :name, :is_verified, :admins, :all_members

      def admins
        @model.college_profiles.where(authority_level: 0).as_json
      end

      def all_members
        college = context[:college]

        college.college_profiles.as_json(include: %i[college_structure college_invite])
      end
    end
  end
end
