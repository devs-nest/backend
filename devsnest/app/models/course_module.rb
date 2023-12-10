# frozen_string_literal: true

# Course Module table
class CourseModule < ApplicationRecord
  has_many :course_curriculums, dependent: :delete_all
  has_many :course_module_accesses, dependent: :delete_all
  has_many :colleges, through: :course_module_accesses, source: :accessor, source_type: 'College'

  # The values of each type of module type are synced in the rest of the enums,
  # Please follow that while adding new module types
  enum module_type: %i[dsa frontend backend]
  enum questions_table: %i[Challenge FrontendChallenge BackendChallenge]
  enum submissions_table: %i[AlgoSubmission FeSubmission BeSubmission]
  enum best_submissions_table: %i[UserChallengeScore FrontendChallengeScore BackendChallengeScore]
  enum timeline_status: %i[new_module comming_soon locked open]
  enum visibility: %i[private_module public_module]

  before_create :sync_rest_columns_with_module_type

  def sync_rest_columns_with_module_type
    sync_order = module_type_before_type_cast
    self.questions_table = self.submissions_table = self.best_submissions_table = sync_order
  end

  # rubocop:disable Metrics/AbcSize
  def activity(college_profile_ids, end_time, top_performing_batches)
    college_profiles = CollegeProfile.includes(:college_structure).where(id: college_profile_ids)

    user_ids = college_profiles.pluck(:user_id).compact.uniq
    question_ids = course_curriculums.includes(:assignment_questions).flat_map do |curriculum|
      curriculum.assignment_questions.pluck(:question_id)
    end
    best_submissions = best_submissions_table.constantize
                                             .where(user_id: user_ids, "#{questions_table.underscore}_id": question_ids)
                                             .where('created_at <= ?', end_time)
                                             .group(:user_id)
                                             .count
    total_questions = questions_table.constantize.where(id: question_ids).count
    course_completion_threshold = (total_questions * 70 / 100)
    passed_students_count = 0

    college_profiles.each do |college_profile|
      structure_name = college_profile.college_structure.name
      top_performing_batches[structure_name] = Hash.new(0) unless top_performing_batches.key?(structure_name)

      user_id = college_profile.user_id
      user_solved = best_submissions[user_id].to_i
      next unless user_solved >= course_completion_threshold

      passed_students_count += 1
      top_performing_batches[structure_name][module_type] += 1
    end

    { module_type => passed_students_count }
  end
  # rubocop:enable Metrics/AbcSize

  def students_active_in_last_month(user_ids)
    question_ids = course_curriculums.includes(:assignment_questions).flat_map do |curriculum|
      curriculum.assignment_questions.pluck(:question_id)
    end

    best_submissions_table.constantize
                          .where(user_id: user_ids, "#{questions_table.underscore}_id": question_ids)
                          .where('created_at >= ?', Time.zone.now - 1.month)
                          .pluck(:user_id)
                          .count
  end
end
