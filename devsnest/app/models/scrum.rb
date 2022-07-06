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
      total_assignments = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge')
      solved_assignments = AlgoSubmission.where(user_id: user_id, challenge_id: total_assignments.pluck(:question_id), is_submitted: true, status: 'Accepted').uniq(&:challenge_id)
      update!(total_assignments_solved: { solved_assignments: solved_assignments.size, total_assignments: total_assignments.size })

      recent_total_assignments = total_assignments.select { |a| a.created_at.between?((Date.today - 15.days).beginning_of_day, Date.today.end_of_day) }.size
      recent_solved_assignments = solved_assignments.select { |a| a.created_at.between?((Date.today - 15.days).beginning_of_day, Date.today.end_of_day) }.uniq(&:challenge_id).size
      update!(recent_assignments_solved: { solved_assignments: recent_solved_assignments, total_assignments: recent_total_assignments })
    end
  end
end
