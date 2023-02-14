# frozen_string_literal: true

module Api
  module V1
    # Bootcamp Progress controller
    class BootcampProgressesController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :add_course_curriculum_id, only: :create

      def complete_day
        course_curriculum_id = params.dig(:data, :attributes, :course_curriculum_id)
        user = User.find_by_id(params.dig(:data, :attributes, :user_id))
        bootcamp_progress = BootcampProgress.find_by(user_id: user.id, course_curriculum_id: course_curriculum_id)
        course_curriculum = CourseCurriculum.find_by_id(course_curriculum_id)
        user_assignment_data = course_curriculum.user_assignment_data(User.find_by_id(user))
        all_questions_completed = user_assignment_data.select { |assignment| [0, 1].include?(assignment[:status]) }.count.zero?
        return render_error(message: 'Questions Not Solved.') unless all_questions_completed

        next_curriculum_id = course_curriculum.next_curriculum_id
        if next_curriculum_id.blank?
          bootcamp_progress.update(completed: true)
          render_success({ message: 'Bootcamp Completed!', bootcamp_progress: bootcamp_progress.as_json })
        else
          bootcamp_progress.update(course_curriculum_id: next_curriculum_id)
          render_success({ message: 'Day Completed!', bootcamp_progress: bootcamp_progress.as_json })
        end
      end

      private

      def add_course_curriculum_id
        course = Course.find_by_id(params.dig(:data, :attributes, :course_id))
        return if course.blank?

        params[:data][:attributes][:course_curriculum_id] = course.course_curriculums.first.try(:id)
      end
    end
  end
end
