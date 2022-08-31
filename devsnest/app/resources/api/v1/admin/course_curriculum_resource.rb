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

          question_ids = AssignmentQuestion.where(course_curriculum: @model).pluck(:question_id).uniq
          case @model.course_type
          when 'dsa'
            submissions_succeded = UserChallengeScore.where(user: context[:user], challenge_id: question_ids).where('passed_test_cases = total_test_cases').pluck(:challenge_id)
            submissions_failed = AlgoSubmission.where(user: context[:user], challenge_id: question_ids, is_submitted: true).where.not(status: 'Accepted').distinct.pluck(:challenge_id)
            assignment_questions_data = Challenge.where(id: question_ids)
          when 'frontend'
            submissions_succeded = FrontendChallengeScore.where(user: context[:user], frontend_challenge_id: question_ids).where('passed_test_cases = total_test_cases').pluck(:frontend_challenge_id)
            submissions_failed = FeSubmission.where(user: context[:user], frontend_challenge_id: question_ids, is_submitted: true).where.not(status: 'Accepted').distinct.pluck(:frontend_challenge_id)
            assignment_questions_data = FrontendChallenge.where(id: question_ids)
          end
          assignment_questions_data.each do |assignment_question|
            question_data = {
              id: assignment_question&.id,
              name: assignment_question&.name,
              slug: assignment_question&.slug,
              status: if submissions_succeded.include?(assignment_question.id)
                        2
                      else
                        submissions_failed.include?(assignment_question.id) ? 1 : 0
                      end
            }
            data << question_data
          end
          data
        end
      end
    end
  end
end
