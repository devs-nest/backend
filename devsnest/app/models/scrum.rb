# frozen_string_literal: true

# scrum model
class Scrum < ApplicationRecord
  validates :user_id, uniqueness: { scope: :creation_date }

  before_create do
    self.creation_date = Date.current
  end
  after_create :update_solved_assignments

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
    current_course = Course.last
    course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
    current_module = 'dsa'
    case current_module
    when 'dsa'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge').pluck(:question_id)
      solved_assignments_count = UserChallengeScore.where(user_id: user_id, challenge_id: total_assignments_challenge_ids).count

      update!(total_assignments_solved: { solved_assignments: solved_assignments_count, total_assignments: total_assignments_challenge_ids.size })

      recent_total_assignments_ch_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge')
                                                          .where('created_at > ?', (Date.today - 15.days).beginning_of_day).pluck(:question_id)
      recent_solved_assignments_count = UserChallengeScore.where(user_id: user_id, challenge_id: recent_total_assignments_ch_ids).count

      update!(recent_assignments_solved: { solved_assignments: recent_solved_assignments_count, total_assignments: recent_total_assignments_ch_ids.size })
    end
  end
end
