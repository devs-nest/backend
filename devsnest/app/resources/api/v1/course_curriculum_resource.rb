# frozen_string_literal: true

module Api
  module V1
    class CourseCurriculumResource < JSONAPI::Resource
      attributes :topic, :course_id, :course_type, :day, :video_link, :resources, :locked
      attributes :assignment_questions

      filter :course_name, apply: lambda { |records, value, _options|
        course = Course.find_by(name: value[0])
        records.where(course_id: course&.id)
      }
      filter :course_type
      filter :day

      def assignment_questions
        @model.user_assignment_data(context[:user])
      end
    end
  end
end
