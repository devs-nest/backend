# frozen_string_literal: true

module Api
  module V1
    class CourseCurriculumResource < JSONAPI::Resource
      attributes :id, :topic, :course_id, :course_type, :day, :video_link, :resources, :locked
      attributes :assignment_questions

      def assignment_questions
        {}
      end
    end
  end
end
