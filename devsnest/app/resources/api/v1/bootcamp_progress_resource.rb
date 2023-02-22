# frozen_string_literal: true

module Api
  module V1
    # Bootcamp Progress resource
    class BootcampProgressResource < JSONAPI::Resource
      attributes :user_id, :course_id, :course_curriculum_id, :completed, :type, :created_at, :updated_at

      def self.creatable_fields(context)
        super - [:completed]
      end

      def type
        @model.course_curriculum.try(:course_type)
      end
    end
  end
end
