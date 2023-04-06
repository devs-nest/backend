# frozen_string_literal: true

# == Schema Information
#
# Table name: course_curriculums
#
#  id          :bigint           not null, primary key
#  course_type :integer
#  day         :integer
#  extra_data  :json
#  locked      :boolean          default(TRUE)
#  resources   :json
#  topic       :string(255)
#  video_link  :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :integer
#
# Indexes
#
#  index_course_curriculums_on_course_id_and_course_type  (course_id,course_type)
#  index_course_curriculums_on_course_id_and_day          (course_id,day)
#
class CourseCurriculum < ApplicationRecord
  belongs_to :course
  enum course_type: %i[dsa frontend backend]
  has_many :assignment_questions

  def next_curriculum_id
    extra_data['next']
  end

  def previous_curriculum_id
    extra_data['previous']
  end

  def user_assignment_data(user)
    data = []
    return data if user.blank?

    question_ids = AssignmentQuestion.where(course_curriculum_id: id).pluck(:question_id).uniq
    case course_type
    when 'dsa'
      submissions_succeded = UserChallengeScore.where(user: user, challenge_id: question_ids).where('passed_test_cases = total_test_cases').pluck(:challenge_id)
      submissions_failed = AlgoSubmission.where(user: user, challenge_id: question_ids, is_submitted: true).where.not(status: 'Accepted').distinct.pluck(:challenge_id)
      assignment_questions_data = Challenge.where(id: question_ids)
    when 'frontend'
      submissions_succeded = FrontendChallengeScore.where(user: user, frontend_challenge_id: question_ids).where('passed_test_cases = total_test_cases').pluck(:frontend_challenge_id)
      submissions_failed = FeSubmission.where(user: user, frontend_challenge_id: question_ids, is_submitted: true).where.not(status: 'Accepted').distinct.pluck(:frontend_challenge_id)
      assignment_questions_data = FrontendChallenge.where(id: question_ids)
    when 'backend'
      submissions_succeded = BackendChallengeScore.where(user: user, backend_challenge_id: question_ids).where('passed_test_cases = total_test_cases').pluck(:backend_challenge_id)
      submissions_failed = BeSubmission.where(user: user, backend_challenge_id: question_ids).where.not(status: 'Accepted').distinct.pluck(:backend_challenge_id)
      assignment_questions_data = BackendChallenge.where(id: question_ids)
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
