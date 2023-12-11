# frozen_string_literal: true

module Api
  module V1
    # Bootcamp Progress controller
    class BootcampProgressesController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :add_course_curriculum_id, only: :create

      def index
        data = @current_user.bootcamp_progress_details
        data.each do |d|
          if d[:course_type] == 'solana' || d[:course_name] == 'dn_airtribe_2023'
            d.merge!(open_to_all: true)
          else
            d.merge!(open_to_all: false)
          end
        end
        render json: { data: data }, status: :ok
      end

      def complete_day
        course_curriculum_id = params.dig(:data, :attributes, :course_curriculum_id)
        user = User.get_by_cache(params.dig(:data, :attributes, :user_id))
        bootcamp_progress = BootcampProgress.find_by(user_id: user.id, course_curriculum_id: course_curriculum_id)
        return render_error(message: 'You have to complete previous day first.') if bootcamp_progress.blank?

        course_curriculum = CourseCurriculum.get_by_cache(course_curriculum_id)
        user_assignment_data = course_curriculum.user_assignment_data(user)
        all_questions_completed = user_assignment_data.select { |assignment| [0, 1].include?(assignment[:status]) }.count.zero?
        return render_error(message: 'Questions Not Solved.') unless all_questions_completed

        next_curriculum_id = course_curriculum.next_curriculum_id
        _previous_curriculum_id = course_curriculum.previous_curriculum_id
        if next_curriculum_id.blank?
          bootcamp_progress.update(completed: true) if bootcamp_progress.completed == false && bootcamp_progress.course_curriculum.course_type != 'solana'
          render_success({ message: 'Bootcamp Completed!', bootcamp_progress: bootcamp_progress.as_json })
        else
          bootcamp_progress.update(course_curriculum_id: next_curriculum_id)
          render_success({ message: 'Day Completed!', bootcamp_progress: bootcamp_progress.as_json })
        end
      end

      private

      def add_course_curriculum_id
        course_module_id = params.dig(:data, :attributes, :course_module_id)

        first_curriculum_id = CourseCurriculum.where(course_module_id: course_module_id).first.try(:id)
        return if first_curriculum_id.blank?

        params[:data][:attributes][:course_curriculum_id] = first_curriculum_id
      end
    end
  end
end
