# frozen_string_literal: true

module Api
  module V1
    class CollegeResource < JSONAPI::Resource
      attributes :name, :is_verified, :admins, :all_members, :college_id, :admin_email
      key_type :string
      primary_key :slug

      # Default value for this filter is true (boolean field)
      filter :is_verified, default: true

      def fetchable_fields
        action = context[:action]
        if action == 'index'
          super - %i[all_members admins]
        elsif action != 'index'
          super - %i[admin_email]
        else
          super
        end
      end

      def college_id
        @model.id
      end

      def admin_email
        @model.college_profiles.where(authority_level: 0).first.try(:email)
      end

      def admins
        @model.college_profiles.where(authority_level: 0).as_json
      end

      def all_members
        @model.college_profiles.where(authority_level: 'student').as_json(include: %i[college_structure college_invite])
      end
    end
  end
end
