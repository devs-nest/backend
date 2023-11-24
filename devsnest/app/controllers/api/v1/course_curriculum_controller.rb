# frozen_string_literal: true

module Api
  module V1
    # Course Curriculum Controller
    class CourseCurriculumController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :set_course_id
      before_action :verify_accessibility

      def context
        { user: @current_user }
      end

      private

      def set_course_id
        if params[:action] == 'index'
          return render_error('course_name is required inside filter') if params.require(:filter).class == String

          params.require(:filter).require(:course_name)
          @course = Course.find_by(name: params[:filter][:course_name])
        elsif params[:action] == 'show'
          @course = CourseCurriculum.find_by_id(params[:id])&.course
        end
      end

      def verify_accessibility
        return true if @course.visibility == "public_course"

        user_access = BootcampAccess.find_by(course_id: @course.id, accessible_id: @current_user.id, accessible_type: 'User')
        college_access = BootcampAccess.find_by(course_id: @course.id, accessible_id: @current_user.college_id, accessible_type: 'College') if @current_user.college_id
        return render_error('You do not have access to the given bootcamp.') if access_not_granted?(user_access) && access_not_granted?(college_access)
      end

      def access_not_granted?(data)
        data.nil? || data[:status] != 'granted'
      end
    end
  end
end
