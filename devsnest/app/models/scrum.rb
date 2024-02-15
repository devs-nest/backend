# frozen_string_literal: true

# == Schema Information
#
# Table name: scrums
#
#  id                        :bigint           not null, primary key
#  attendance                :boolean
#  backlog_reasons           :text(65535)
#  class_rating              :integer
#  creation_date             :date
#  last_tha_link             :string(255)
#  recent_assignments_solved :json
#  saw_last_lecture          :boolean
#  tha_progress              :string(255)
#  topics_to_cover           :string(255)
#  total_assignments_solved  :json
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  group_id                  :integer
#  user_id                   :integer
#
# Indexes
#
#  index_scrums_on_user_id_and_creation_date  (user_id,creation_date) UNIQUE
#
class Scrum < ApplicationRecord
  validates :user_id, uniqueness: { scope: :creation_date }

  before_create do
    self.creation_date = Date.current
  end
  after_create :update_solved_assignments
  after_commit :update_activity_points, only: %i[create update]

  def update_activity_points
    group = Group.find_by(id: group_id)
    group.update(activity_point: group.count_activity_point) if group.present?
  end

  def handle_manual_update(params, group, user)
    if group.admin_rights_auth(user)
      params = (params.dig 'data', 'attributes').except(:user_id, :group_id, :creation_date)
      params = params.permit(:attendance, :saw_last_lecture, :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating)
    else
      params = (params.dig 'data', 'attributes').except(:user_id, :group_id, :creation_date, :attendance)
      params = params.permit(:saw_last_lecture, :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating)
    end
    update!(params)
  end

  def update_solved_assignments
    current_course = group.course || Course.first # Adding Course.first for handling old groups
    course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
    current_module = current_course.current_module
    case current_module
    when 'dsa'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge').pluck(:question_id).uniq
      solved_assignments_count = UserChallengeScore.where(user_id: user_id, challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count

      recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge')
                                                          .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id).uniq
      recent_solved_assignments_count = UserChallengeScore.where(user_id: user_id, challenge_id: recent_total_assignments_ch_ids).where('passed_test_cases = total_test_cases').count

      update!(recent_assignments_solved: { solved_assignments: recent_solved_assignments_count, total_assignments: recent_total_assignments_ch_ids.size },
              total_assignments_solved: { solved_assignments: solved_assignments_count, total_assignments: total_assignments_challenge_ids.size })
    when 'frontend'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'FrontendChallenge').pluck(:question_id).uniq
      solved_assignments_count = FrontendChallengeScore.where(user_id: user_id, frontend_challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count

      recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'FrontendChallenge')
                                                          .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id).uniq
      recent_solved_assignments_count = FrontendChallengeScore.where(user_id: user_id, frontend_challenge_id: recent_total_assignments_ch_ids).where('passed_test_cases = total_test_cases').count

      update!(recent_assignments_solved: { solved_assignments: recent_solved_assignments_count, total_assignments: recent_total_assignments_ch_ids.size },
              total_assignments_solved: { solved_assignments: solved_assignments_count, total_assignments: total_assignments_challenge_ids.size })
    when 'backend'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'BackendChallenge').pluck(:question_id).uniq
      solved_assignments_count = BackendChallengeScore.where(user_id: user_id, backend_challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count

      recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'BackendChallenge')
                                                          .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id).uniq
      recent_solved_assignments_count = BackendChallengeScore.where(user_id: user_id, backend_challenge_id: recent_total_assignments_ch_ids).where('passed_test_cases = total_test_cases').count

      update!(recent_assignments_solved: { solved_assignments: recent_solved_assignments_count, total_assignments: recent_total_assignments_ch_ids.size },
              total_assignments_solved: { solved_assignments: solved_assignments_count, total_assignments: total_assignments_challenge_ids.size })
    end
  end

  def weekly_leaderboard_data
    data = Scrum.where(creation_date: Date.today.last_week.beginning_of_week..Date.today.last_week.end_of_week, attendance: true).group(:group_id).count

    sorted_data = Hash[data.sort_by { |_, v| -v }]
    result = []
    sorted_data.each do |group_id, scrums|
      group = Group.find_by(id: group_id)
      next unless group.present? && group.group_type == 'public'

      result.append({
                      group_slug: group.slug,
                      group_name: group.name,
                      members_count: group.members_count,
                      scrums: scrums
                    })
    end
    result
  end
end
