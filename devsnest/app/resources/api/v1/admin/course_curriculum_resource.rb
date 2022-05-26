# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Course Curriculum Resource
      class CourseCurriculumResource < JSONAPI::Resource
        attributes :id, :topic, :course_id, :course_type, :day, :video_link, :resources, :locked
        attributes :assignment_questions

        filter :course_name, apply: lambda { |records, value, _options|
          course = Course.find_by(name: value[0])
          records.where(course_id: course&.id)
        }
        filter :course_type
        filter :day

        def assignment_questions
          data = []
          return data if context[:user].blank?

          assignment_questions_data = AssignmentQuestion.where(course_curriculum: @model).map(&:question)
          assignment_questions_data.each do |assignment_question|
            question_data = {
              name: assignment_question&.name,
              slug: assignment_question&.slug,
              status: 0
            }
            algo_submissions = AlgoSubmission.where(user: context[:user], challenge_id: assignment_question&.id, is_submitted: true)
            if algo_submissions.present?
              status = algo_submissions.where(status: 'Accepted').present? ? 2 : 1
              question_data[:status] = status
            end
            data << question_data
          end
          data
        end
      end
    end
  end
end
