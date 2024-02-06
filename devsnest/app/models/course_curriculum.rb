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
  belongs_to :course, optional: true
  belongs_to :course_module
  enum course_type: %i[dsa frontend backend solana]
  has_many :assignment_questions
  serialize :contents, Array

  after_create :update_extra_data

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
    when 'solana'
      submissions_succeded = ArticleSubmission.where(user: user, article_id: question_ids).pluck(:article_id)
      submissions_failed = []
      assignment_questions_data = Article.where(id: question_ids).map do |question|
        {
          id: question.id,
          name: question.title,
          slug: question.slug
        }
      end
    end
    assignment_questions_data.each do |assignment_question|
      question_data = {
        id: assignment_question[:id],
        name: assignment_question[:name],
        slug: assignment_question[:slug],
        status: if submissions_succeded.include?(assignment_question[:id])
                  2
                else
                  submissions_failed.include?(assignment_question[:id]) ? 1 : 0
                end
      }
      data << question_data
    end
    data
  end

  def update_extra_data
    course_curriculums = CourseCurriculum.where(course_module_id: course_module_id)
    if course_curriculums.count > 1
      prev_course_curriculum = course_curriculums.second_to_last
      update!(extra_data: {
                next: nil,
                previous: prev_course_curriculum.id
              })
      prev_course_curriculum.update!(extra_data: {
                                       next: id,
                                       previous: prev_course_curriculum.extra_data['previous']
                                     })
    else
      update!(extra_data: {})
    end
  end
end
