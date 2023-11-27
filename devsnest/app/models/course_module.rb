# frozen_string_literal: true

# Course Module table
class CourseModule < ApplicationRecord
  belongs_to :course
  has_many :course_curriculums, dependent: :delete_all

  # The values of each type of module type are synced in the rest of the enums,
  # Please follow that while adding new module types
  enum module_type: %i[dsa frontend backend]
  enum questions_table: %i[Challenge FrontendChallenge BackendChallenge]
  enum submissions_table: %i[AlgoSubmission FeSubmission BeSubmission]
  enum best_submissions_table: %i[UserChallengeScore FrontendChallengeScore BackendChallengeScore]

  before_create :sync_rest_columns_with_module_type

  def sync_rest_columns_with_module_type
    sync_order = module_type_before_type_cast
    self.questions_table = self.submissions_table = self.best_submissions_table = sync_order
  end

  # rubocop:disable Metrics/AbcSize
  def activity(user_ids, end_time)
    question_ids = course_curriculums.includes(:assignment_questions).flat_map do |curriculum|
      curriculum.assignment_questions.pluck(:question_id)
    end
    best_submissions = best_submissions_table.constantize.where("user_id = ? AND #{questions_table.underscore}_id = ?", user_ids, question_ids)
                                             .where('created_at <= ?', end_time).group(:user_id).count
    total_questions = questions_table.constantize.where(is_active: true).count
    course_completion_threshold = (total_questions * 70 / 100)
    passed_students_count = 0

    user_ids.each do |user_id|
      user_solved = best_submissions[user_id].to_i
      passed_students_count += 1 if user_solved >= course_completion_threshold
    end

    { "students_completed_#{module_type}_bootcamp": passed_students_count }
  end
  # rubocop:enable Metrics/AbcSize
end
