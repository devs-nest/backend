# frozen_string_literal: true

module Api
  module V1
    # Bootcamp Progress resource
    class BootcampProgressResource < JSONAPI::Resource
      attributes :user_id, :course_id, :course_curriculum_id, :completed, :created_at, :updated_at
      filter :user_id

      def self.creatable_fields(context)
        super - [:completed]
      end
    end
  end
end
