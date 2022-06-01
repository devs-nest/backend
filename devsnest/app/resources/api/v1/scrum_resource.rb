# frozen_string_literal: true

module Api
  module V1
    # Resource for Scrum
    class ScrumResource < JSONAPI::Resource
      attributes :user_id, :group_id, :attendance, :saw_last_lecture,
                 :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating, :creation_date, :last_tha_link,
                 :total_assignments_solved, :recent_assignments_solved

      def self.creatable_fields(context)
        group = Group.find_by(id: context[:group_id_create])
        user = context[:user]
        if group.admin_rights_auth(user)
          super
        else
          super - %i[attendance]
        end
      end

      def self.updatable_fields(context)
        scrum = Scrum.find_by(id: context[:scrum_id])
        group = Group.find_by(id: scrum.group_id)
        if group.admin_rights_auth(context[:user])
          super - %i[user_id group_id creation_date]
        else
          super - %i[attendance user_id group_id creation_date]
        end
      end

      def self.records(options = {})
        group = Group.find_by(id: options[:context][:group_id_get])
        if group.present?
          super(options).where(group_id: group.id, creation_date: Date.parse(options[:context][:date]))
        else

          super(options)
        end
      end

      def total_assignments_solved
        current_course = Course.last
        course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
        current_module = 'dsa'
        case current_module
        when 'dsa'
          total_assignments = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge')
          solved_assignments = AlgoSubmission.where(user_id: @model.user_id, challenge_id: total_assignments.pluck(:id), is_submitted: true, status: 'Accepted').uniq(&:challenge_id)
          {
            solved_assignments: solved_assignments.count,
            total_assignments: total_assignments.count
          }
        end
      end

      def recent_assignments_solved
        current_course = Course.last
        course_curriculum_ids = current_course&.course_curriculums&.pluck(:id) || []
        current_module = 'dsa'
        case current_module
        when 'dsa'
          total_assignments = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge',
                                                       created_at: (Date.today - 15.days).beginning_of_day..Date.today.end_of_day)
          solved_assignments = AlgoSubmission.where(user_id: 6712, challenge_id: total_assignments.pluck(:id), is_submitted: true, status: 'Accepted',
                                                    created_at: (Date.today - 15.days).beginning_of_day..Date.today.end_of_day).uniq(&:challenge_id)
          {
            solved_assignments: solved_assignments.count,
            total_assignments: total_assignments.count
          }
        end
      end
    end
  end
end
