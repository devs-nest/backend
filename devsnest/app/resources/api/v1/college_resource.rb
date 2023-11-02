# frozen_string_literal: true

module Api
  module V1
    class CollegeResource < JSONAPI::Resource
      attributes :name, :is_verified, :admins, :all_members, :college_id
      key_type :string
      primary_key :slug

      def college_id
        @model.id
      end

      def admins
        @model.college_profiles.where(authority_level: 0).as_json
      end

      def all_members
        college = context[:college]
        return {} if college.blank?

        college.college_profiles.where(authority_level: 'student').as_json(include: %i[college_structure college_invite])
      end
    end
  end
end
