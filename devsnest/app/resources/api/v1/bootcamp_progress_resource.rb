# frozen_string_literal: true

module Api
  module V1
    # Bootcamp Progress resource
    class BootcampProgressResource < JSONAPI::Resource
      attributes :user_id, :course_id, :course_curriculum_id, :completed, :created_at, :updated_at, :course_module_id
      attributes :course_type

      def self.creatable_fields(context)
        super - [:completed]
      end

      def course_type
        @model.course_curriculum.try(:course_type)
      end
    end
  end
end
